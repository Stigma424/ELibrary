using System;
using System.Security.Cryptography;

namespace ELibrary
{
    public static class PasswordHelper
    {
        private const int SaltSize = 16;
        private const int HashSize = 32;
        private const int Iterations = 100000;

        public static string HashPassword(string password)
        {
            byte[] salt = new byte[SaltSize];

            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password,
                salt,
                Iterations))
            {
                byte[] hash = pbkdf2.GetBytes(HashSize);

                return Convert.ToBase64String(salt) + ":" +
                       Convert.ToBase64String(hash);
            }
        }

        public static bool VerifyPassword(
            string password,
            string storedPassword)
        {
            if (string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(storedPassword))
            {
                return false;
            }

            string[] parts = storedPassword.Split(':');

            if (parts.Length != 2)
            {
                return false;
            }

            try
            {
                byte[] salt =
                    Convert.FromBase64String(parts[0]);

                byte[] storedHash =
                    Convert.FromBase64String(parts[1]);

                using (var pbkdf2 = new Rfc2898DeriveBytes(
                    password,
                    salt,
                    Iterations))
                {
                    byte[] computedHash =
                        pbkdf2.GetBytes(HashSize);

                    return SlowEquals(
                        computedHash,
                        storedHash);
                }
            }
            catch
            {
                return false;
            }
        }

        private static bool SlowEquals(
            byte[] a,
            byte[] b)
        {
            uint diff =
                (uint)a.Length ^ (uint)b.Length;

            int length = Math.Min(a.Length, b.Length);

            for (int i = 0; i < length; i++)
            {
                diff |= (uint)(a[i] ^ b[i]);
            }

            return diff == 0;
        }
    }
}