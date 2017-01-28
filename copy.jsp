create or replace and compile java source named U1."Copy" as
// Java library imports.
  import java.io.File;
  import java.io.IOException;
  import java.io.FileReader;
  import java.io.FileWriter;
  import javax.imageio.stream.FileImageInputStream;
  import javax.imageio.stream.FileImageOutputStream;
  import java.security.AccessControlException;

  // Class definition.
  public class Copy
  {
    // Define variable(s).
    private static int c;
    private static File file1,file2;
    private static FileReader inTextFile;
    private static FileWriter outTextFile;
    private static FileImageInputStream inImageFile;
    private static FileImageOutputStream outImageFile;

    // Define copyText() method.
    public static int copyText(String fromFile,String toFile) throws AccessControlException
    {
      // Create files from canonical file names.
      file1 = new File(fromFile);
      file2 = new File(toFile);

      // Copy file(s).
      try
      {
        // Define and initialize FileReader(s).
        inTextFile  = new FileReader(file1);
        outTextFile = new FileWriter(file2);

        // Delete older file when present.
        if (file2.isFile() & file2.delete()) {}

        // Read character-by-character.
        while ((c = inTextFile.read()) != -1) {
          outTextFile.write(c); }

        // Close Stream(s).
        inTextFile.close();
        outTextFile.close(); }
      catch (IOException e) {
        return 0; }
    return 1; }

    // Define copyImage() method.
    public static int copyImage(String fromFile,String toFile) throws AccessControlException
    {
      // Create files from canonical file names.
      file1 = new File(fromFile);
      file2 = new File(toFile);

      // Copy file(s).
      try
      {

      // Define and initialize FileReader(s).
      inImageFile  = new FileImageInputStream(file1);
      outImageFile = new FileImageOutputStream(file2);

      // Delete older file when present.
      if (file2.isFile() & file2.delete()) {}

      // Read character-by-character.
      while ((c = inImageFile.read()) != -1) {
        outImageFile.write(c); }

      // Close Stream(s).
      inImageFile.close();
      outImageFile.close(); }
    catch (IOException e) {
      return 0; }
    return 1; }}
/

