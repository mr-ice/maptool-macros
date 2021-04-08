all: CampaignMerge.class

%.class: %.java
	javac $<
	
clean:
	rm -f *.class *.zip *.xml

test: CampaignMerge.class
	java CampaignMerge ../One/content.xml ../Two/content.xml Merged-One-Two.zip
