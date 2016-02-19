<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:cat="http://standards.iso.org/19115/-3/cat/1.0"
                xmlns:cit="http://standards.iso.org/19115/-3/cit/1.0"
                xmlns:gcx="http://standards.iso.org/19115/-3/gcx/1.0"
                xmlns:gex="http://standards.iso.org/19115/-3/gex/1.0"
                xmlns:lan="http://standards.iso.org/19115/-3/lan/1.0"
                xmlns:srv2="http://standards.iso.org/19115/-3/srv/2.0"
                xmlns:mas="http://standards.iso.org/19115/-3/mas/1.0"
                xmlns:mcc="http://standards.iso.org/19115/-3/mcc/1.0"
                xmlns:mco="http://standards.iso.org/19115/-3/mco/1.0"
                xmlns:mda="http://standards.iso.org/19115/-3/mda/1.0"
                xmlns:mdb="http://standards.iso.org/19115/-3/mdb/1.0"
                xmlns:mds="http://standards.iso.org/19115/-3/mds/1.0"
                xmlns:mdt="http://standards.iso.org/19115/-3/mdt/1.0"
                xmlns:mex="http://standards.iso.org/19115/-3/mex/1.0"
                xmlns:mmi="http://standards.iso.org/19115/-3/mmi/1.0"
                xmlns:mpc="http://standards.iso.org/19115/-3/mpc/1.0"
                xmlns:mrc="http://standards.iso.org/19115/-3/mrc/1.0"
                xmlns:mrd="http://standards.iso.org/19115/-3/mrd/1.0"
                xmlns:mri="http://standards.iso.org/19115/-3/mri/1.0"
                xmlns:mrl="http://standards.iso.org/19115/-3/mrl/1.0"
                xmlns:mrs="http://standards.iso.org/19115/-3/mrs/1.0"
                xmlns:msr="http://standards.iso.org/19115/-3/msr/1.0"
                xmlns:mdq="http://standards.iso.org/19157/-2/mdq/1.0"
                xmlns:mac="http://standards.iso.org/19115/-3/mac/1.0"
                xmlns:gco2="http://standards.iso.org/19115/-3/gco/1.0"
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
      <!-- TODO ? should we move sinp:observationDetails ? -->
    </gmd:MD_DataIdentification>
  </xsl:template>

  <!-- TODO ? should we move sinp:database ? -->

  <xsl:template match="sinp:*"/>
</xsl:stylesheet>
