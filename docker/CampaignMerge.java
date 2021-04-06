import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

import net.rptools.maptool.model.CampaignProperties;
import net.rptools.maptool.util.PersistenceUtil;
import net.rptools.lib.io.PackedFile;

import org.apache.commons.io.IOUtils;

public class CampaignMerge {

    public static void main(String[] args) {
        if (args.length != 3) {
            System.out.println("Usage: CampaignMerge <fileIn1> <fileIn2> <fileNameOut>");
            System.exit(1);
        }
        final File firstFile = new File(args[0]);
        final File mergeFile = new File(args[1]);

        CampaignProperties properties = PersistenceUtil.loadCampaignProperties(firstFile);
        CampaignProperties mergeProperties = PersistenceUtil.loadCampaignProperties(mergeFile);

        // current assumption is that the properties.mergeCampaignProperties changes properties
        mergeProperties.mergeInto(properties);

        try (PackedFile pak1File = new PackedFile(new File("MP.zip"))) {
            pak1File.removeAll();
            // clearAssets(pakFile);
            // saveAssets(campaign.getCampaignProperties().getAllImageAssets(), pakFile);
            pak1File.setContent(mergeProperties);
            // pakFile.setProperty("version", "1.8.4");
            pak1File.save();
        }
        catch (IOException e) {
            System.out.println("Got IOException saving mergeProperties");
        }
        try (PackedFile pakFile = new PackedFile(new File(args[2]))) {
            pakFile.removeAll();
            // clearAssets(pakFile);
            // saveAssets(campaign.getCampaignProperties().getAllImageAssets(), pakFile);
            pakFile.setContent(properties);
            // pakFile.setProperty("version", "1.8.4");
            pakFile.save();
        }
        catch (IOException e) {
            System.out.println("Got IOException");
        }
        // System.out.println(properties);

        System.out.println("Merged " + firstFile.getAbsolutePath() + " with " + mergeFile.getAbsolutePath() + " into " + args[2]);
    }
}

