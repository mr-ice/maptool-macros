all: /usr/local/libexec/CampaignMerge.class

%.class: %.java
	javac $<
	
test: all
	(CampaignMerge ../DND5e1/content.xml ../altCampaignProps/content.xml junk.zip) 2>&1 | head
