<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd">
    <xsl:import href="../iso19139/update-fixed-info.xsl"/>

    <!-- Force presence of uuid attribute on contact
    and init them with a random UUID. -->
    <xsl:template match="sinp:CI_ResponsibleParty">
        <xsl:copy>
            <xsl:if test="not(@uuid)">
                <xsl:attribute name="uuid"
                               select="uuid:randomUUID()" xmlns:uuid="java.util.UUID"/>
            </xsl:if>
            <xsl:apply-templates select="@*|*"/>
        </xsl:copy>
    </xsl:template>


    <!-- Add metadata creation date in metadata maintenance section
    if not available. That is not perfect, but works to store the info. -->
    <xsl:template match="gmd:MD_Metadata[not(gmd:metadataMaintenance)]">
        <xsl:variable name="dateFormat" as="xs:string"
                      select="'[Y0001]-[M01]-[D01]T[H01]:[m01]:[s01]'"/>

        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="gmd:fileIdentifier|
                        gmd:language|
                        gmd:characterSet|
                        gmd:parentIdentifier|
                        gmd:hierarchyLevel|
                        gmd:hierarchyLevelName|
                        gmd:contact|
                        gmd:dateStamp|
                        gmd:metadataStandardName|
                        gmd:metadataStandardVersion|
                        gmd:dataSetURI|
                        gmd:locale|
                        gmd:spatialRepresentationInfo|
                        gmd:referenceSystemInfo|
                        gmd:metadataExtensionInfo|
                        gmd:identificationInfo|
                        gmd:contentInfo|
                        gmd:distributionInfo|
                        gmd:dataQualityInfo|
                        gmd:portrayalCatalogueInfo|
                        gmd:metadataConstraints|
                        gmd:applicationSchemaInfo"/>

            <gmd:metadataMaintenance>
                <gmd:MD_MaintenanceInformation>
                    <gmd:maintenanceAndUpdateFrequency>
                        <gmd:MD_MaintenanceFrequencyCode
                                codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                codeListValue="irregular"/>
                    </gmd:maintenanceAndUpdateFrequency>
                    <gmd:dateOfNextUpdate>
                        <gco:Date><xsl:value-of select="xs:dateTime(current-dateTime())"/></gco:Date>
                    </gmd:dateOfNextUpdate>
                    <gmd:updateScopeDescription/>
                    <gmd:maintenanceNote>
                        <gco:CharacterString>Date de création de la métadonnée</gco:CharacterString>
                    </gmd:maintenanceNote>
                </gmd:MD_MaintenanceInformation>
            </gmd:metadataMaintenance>

            <xsl:apply-templates select="gmd:series|
                        gmd:describes|
                        gmd:propertyType|
                        gmd:featureType|
                        gmd:featureAttribute"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
