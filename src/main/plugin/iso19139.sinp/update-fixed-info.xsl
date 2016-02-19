<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
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
</xsl:stylesheet>
