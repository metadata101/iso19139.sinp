<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:gml2="http://www.opengis.net/gml/3.2"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gfc="http://www.isotc211.org/2005/gfc"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:gmi="http://www.isotc211.org/2005/gmi"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
                exclude-result-prefixes="#all"
                xmlns:srv="http://www.isotc211.org/2005/srv">
  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!--Copy -->
  <xsl:template match="*" priority="-10">
    <xsl:element name="{name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:if test="not (local-name() = 'type')">
      <xsl:attribute name="{name()}">
        <xsl:value-of select="."/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="sinp:CI_ResponsibleParty" priority="2">
    <gmd:CI_ResponsibleParty>
      <xsl:apply-templates select="*"/>
    </gmd:CI_ResponsibleParty>
  </xsl:template>

  <xsl:template match="sinp:DispositifIdentification" priority="2">
    <gmd:MD_DataIdentification>
      <xsl:apply-templates select="*"/>
    </gmd:MD_DataIdentification>
  </xsl:template>

  <xsl:template match="sinp:*"/>
</xsl:stylesheet>
