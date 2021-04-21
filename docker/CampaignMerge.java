import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.IOException;
import net.rptools.maptool.model.CampaignProperties;
import net.rptools.maptool.util.PersistenceUtil;
import net.rptools.lib.io.PackedFile;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.status.StatusLogger;


public class CampaignMerge {
    public static void main(String[] args) {
        // First, shut up the StatusLogger errors we inherit from MapTool
        StatusLogger.getLogger().setLevel(Level.OFF);

        // Next, basic check that we have enough arguments
        if (args.length != 2) {
            System.out.println("Usage: CampaignMerge <fileIn1> <fileIn2>");
            System.exit(1);
        }

        // check that we were given existing files to open
        final File firstFile = new File(args[0]);
        // TODO: check that they are xml
        // TODO: check that they are campaignProperties
        final File mergeFile = new File(args[1]);

        // load the files via MapTool persistence tools so we get
        // a CampaignProperties object.
        CampaignProperties properties = PersistenceUtil.loadCampaignProperties(firstFile);
        CampaignProperties mergeProperties = PersistenceUtil.loadCampaignProperties(mergeFile);

        // merge into properties, not sure if one or both is changed, I'm pretty sure
        // the argument gets the bulk of the changes, but testing shows both get changed.
        mergeProperties.mergeInto(properties);

        // create a PackedFile from MapTool so that we can run the
        // new CampaignProperties through it to serialize it.  We don't
        // write this but we apparently do need to give it a filename.
        try (PackedFile pakFile = new PackedFile(new File("junk.zip"))) {
            pakFile.removeAll();
            pakFile.setContent(mergeProperties);
            String thisLine = null;
            BufferedReader contentFile = pakFile.getFileAsReader("content.xml");
            while ((thisLine = contentFile.readLine()) != null) {
                System.out.println(thisLine);
            } 
            // pakFile.save();
        }
        catch (IOException e) {
            System.err.println("Got IOException saving mergeProperties");
        }
    }
}

