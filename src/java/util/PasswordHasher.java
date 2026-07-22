package util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.spec.InvalidKeySpecException;
import java.util.Base64;
import java.util.logging.Logger;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

/**
 * Salted password hashing built on PBKDF2, which ships with the JDK. No extra
 * jar is needed, so this works in NetBeans and in the Docker image alike.
 *
 * Stored format:  pbkdf2$&lt;iterations&gt;$&lt;base64 salt&gt;$&lt;base64 hash&gt;
 *
 * Rows written before hashing was introduced hold the password in plain text.
 * {@link #matches} still accepts those so nobody is locked out, and
 * {@link #needsUpgrade} reports them so the caller can rewrite the row with a
 * real hash the next time the user signs in successfully.
 */
public final class PasswordHasher {

    private static final Logger LOGGER = Logger.getLogger(PasswordHasher.class.getName());

    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final String PREFIX = "pbkdf2$";
    private static final int ITERATIONS = 120_000;
    private static final int SALT_BYTES = 16;
    private static final int KEY_BITS = 256;

    private static final SecureRandom RANDOM = new SecureRandom();

    private PasswordHasher() {
    }

    /** Produces a storable hash for a new or changed password. */
    public static String hash(String rawPassword) {
        if (rawPassword == null) {
            rawPassword = "";
        }
        byte[] salt = new byte[SALT_BYTES];
        RANDOM.nextBytes(salt);
        byte[] key = derive(rawPassword.toCharArray(), salt, ITERATIONS);

        return PREFIX + ITERATIONS
                + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(key);
    }

    /**
     * Checks a submitted password against whatever is stored, whether that is a
     * PBKDF2 hash or a legacy plain-text value.
     */
    public static boolean matches(String rawPassword, String stored) {
        if (rawPassword == null || stored == null || stored.isEmpty()) {
            return false;
        }

        if (!isHashed(stored)) {
            // Legacy row. Constant-time compare so this path leaks no timing
            // information either.
            return constantTimeEquals(
                    rawPassword.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                    stored.getBytes(java.nio.charset.StandardCharsets.UTF_8));
        }

        String[] parts = stored.split("\\$");
        if (parts.length != 4) {
            LOGGER.warning("Stored password hash is malformed; rejecting.");
            return false;
        }

        try {
            int iterations = Integer.parseInt(parts[1]);
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            byte[] actual = derive(rawPassword.toCharArray(), salt, iterations);
            return constantTimeEquals(expected, actual);
        } catch (IllegalArgumentException ex) {
            LOGGER.warning("Could not parse stored password hash: " + ex.getMessage());
            return false;
        }
    }

    /** True when the stored value is plain text and should be re-hashed. */
    public static boolean needsUpgrade(String stored) {
        return stored != null && !stored.isEmpty() && !isHashed(stored);
    }

    private static boolean isHashed(String stored) {
        return stored.startsWith(PREFIX);
    }

    private static byte[] derive(char[] password, byte[] salt, int iterations) {
        try {
            PBEKeySpec spec = new PBEKeySpec(password, salt, iterations, KEY_BITS);
            try {
                return SecretKeyFactory.getInstance(ALGORITHM).generateSecret(spec).getEncoded();
            } finally {
                spec.clearPassword();
            }
        } catch (NoSuchAlgorithmException ex) {
            // Every supported JRE ships PBKDF2WithHmacSHA256. Failing loudly is
            // correct here: silently weakening the hash would be worse.
            throw new IllegalStateException("PBKDF2 is unavailable on this JRE", ex);
        } catch (InvalidKeySpecException ex) {
            throw new IllegalStateException("Invalid PBKDF2 key specification", ex);
        }
    }

    /** Compares without an early exit, so timing does not reveal the prefix. */
    private static boolean constantTimeEquals(byte[] a, byte[] b) {
        return MessageDigest.isEqual(a, b);
    }
}
