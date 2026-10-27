using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Text;
using System.Windows.Forms;

internal static class MaruPilotLauncher
{
    [STAThread]
    private static int Main()
    {
        string iconPath = null;
        string scriptPath = null;
        try
        {
            string script;
            using (Stream stream = Assembly.GetExecutingAssembly().GetManifestResourceStream("MaruPilot.ps1"))
            {
                if (stream == null)
                {
                    throw new InvalidOperationException("В EXE не найден файл приложения MaruPilot.ps1.");
                }

                using (StreamReader reader = new StreamReader(stream, Encoding.UTF8, true))
                {
                    script = reader.ReadToEnd();
                }
            }

            scriptPath = Path.Combine(Path.GetTempPath(), "MaruPilot-" + Guid.NewGuid().ToString("N") + ".ps1");
            File.WriteAllText(scriptPath, script, new UTF8Encoding(true));

            iconPath = Path.Combine(Path.GetTempPath(), "MaruPilot-" + Guid.NewGuid().ToString("N") + ".png");
            using (Stream iconStream = Assembly.GetExecutingAssembly().GetManifestResourceStream("MaruPilot.icon.png"))
            {
                if (iconStream == null)
                {
                    throw new InvalidOperationException("В EXE не найден файл значка icon.png.");
                }

                using (FileStream iconFile = File.Create(iconPath))
                {
                    iconStream.CopyTo(iconFile);
                }
            }

            ProcessStartInfo startInfo = new ProcessStartInfo
            {
                FileName = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.System), "WindowsPowerShell\\v1.0\\powershell.exe"),
                Arguments = "-NoProfile -STA -ExecutionPolicy Bypass -File \"" + scriptPath + "\"",
                UseShellExecute = false,
                CreateNoWindow = true,
                WindowStyle = ProcessWindowStyle.Hidden
            };
            startInfo.EnvironmentVariables["MARUPILOT_ICON_PATH"] = iconPath;
            startInfo.EnvironmentVariables["MARUPILOT_EXECUTABLE"] = Assembly.GetExecutingAssembly().Location;

            using (Process process = Process.Start(startInfo))
            {
                process.WaitForExit();
                return process.ExitCode;
            }
        }
        catch (Exception exception)
        {
            MessageBox.Show(
                "Не удалось запустить MaruPilot: " + exception.Message,
                "MaruPilot",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
            return 1;
        }
        finally
        {
            if (scriptPath != null && File.Exists(scriptPath))
            {
                try
                {
                    File.Delete(scriptPath);
                }
                catch (IOException)
                {
                }
                catch (UnauthorizedAccessException)
                {
                }
            }

            if (iconPath != null && File.Exists(iconPath))
            {
                try
                {
                    File.Delete(iconPath);
                }
                catch (IOException)
                {
                }
                catch (UnauthorizedAccessException)
                {
                }
            }
        }
    }
}
