using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Web;
using System.Web.UI.WebControls;

namespace ELibrary
{
    public static class ImageUploadHelper
    {
        private const int MaxFileBytes = 2 * 1024 * 1024;
        private const int MaxDimension = 4000;
        private const long MaxPixels = 12000000;

        public static string SaveImage(
            FileUpload upload,
            string folderVirtualPath)
        {
            if (upload == null || !upload.HasFile)
            {
                throw new InvalidOperationException(
                    "Please select an image.");
            }

            if (upload.PostedFile.ContentLength <= 0 ||
                upload.PostedFile.ContentLength > MaxFileBytes)
            {
                throw new InvalidOperationException(
                    "Image size must not exceed 2 MB.");
            }

            string extension = Path.GetExtension(
                upload.FileName).ToLowerInvariant();

            if (extension != ".jpg" &&
                extension != ".jpeg" &&
                extension != ".png")
            {
                throw new InvalidOperationException(
                    "Only JPG and PNG images are allowed.");
            }

            string folder = folderVirtualPath.TrimEnd('/') + "/";

            if (folder != "~/Uploads/BookCovers/" &&
                folder != "~/Uploads/ProfilePictures/")
            {
                throw new InvalidOperationException(
                    "Invalid upload destination.");
            }

            string physicalFolder =
                HttpContext.Current.Server.MapPath(folder);

            Directory.CreateDirectory(physicalFolder);

            byte[] bytes;

            using (MemoryStream buffer = new MemoryStream())
            {
                upload.PostedFile.InputStream.CopyTo(buffer);
                bytes = buffer.ToArray();
            }

            using (MemoryStream source = new MemoryStream(bytes))
            using (System.Drawing.Image image =
          System.Drawing.Image.FromStream(source, false, true))
            {
                bool isJpeg =
                    image.RawFormat.Guid == ImageFormat.Jpeg.Guid;

                bool isPng =
                    image.RawFormat.Guid == ImageFormat.Png.Guid;

                if (!isJpeg && !isPng)
                {
                    throw new InvalidOperationException(
                        "The uploaded file is not a valid JPG or PNG image.");
                }

                if ((isJpeg && extension == ".png") ||
                    (isPng && extension != ".png"))
                {
                    throw new InvalidOperationException(
                        "The file extension does not match the image format.");
                }

                if (image.Width > MaxDimension ||
                    image.Height > MaxDimension ||
                    (long)image.Width * image.Height > MaxPixels)
                {
                    throw new InvalidOperationException(
                        "Image dimensions are too large.");
                }

                string savedExtension = isPng ? ".png" : ".jpg";
                string fileName =
                    Guid.NewGuid().ToString("N") + savedExtension;

                string physicalPath =
                    Path.Combine(physicalFolder, fileName);

                using (Bitmap bitmap = new Bitmap(image))
                {
                    if (extension == ".png")
                    {
                        bitmap.Save(physicalPath, ImageFormat.Png);
                    }
                    else
                    {
                        bitmap.Save(physicalPath, ImageFormat.Jpeg);
                    }
                }
                return folder + fileName;
            }
        }

        public static void DeleteImage(string virtualPath)
        {
            if (string.IsNullOrWhiteSpace(virtualPath))
                return;

            string normalized = virtualPath.Replace('\\', '/');

            if (!normalized.StartsWith(
                "~/Uploads/BookCovers/",
                StringComparison.Ordinal) &&
                !normalized.StartsWith(
                "~/Uploads/ProfilePictures/",
                StringComparison.Ordinal))
            {
                return;
            }

            string fileName = Path.GetFileName(normalized);

            if (string.IsNullOrEmpty(fileName) ||
                normalized !=
                    (normalized.StartsWith("~/Uploads/BookCovers/")
                        ? "~/Uploads/BookCovers/"
                        : "~/Uploads/ProfilePictures/") + fileName)
            {
                return;
            }

            string physicalPath =
                HttpContext.Current.Server.MapPath(normalized);

            if (File.Exists(physicalPath))
            {
                File.Delete(physicalPath);
            }
        }
    }
}