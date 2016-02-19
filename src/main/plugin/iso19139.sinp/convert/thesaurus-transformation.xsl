<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:geonet="http://www.fao.org/geonetwork"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:util="java:org.fao.geonet.util.XslUtil"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
                exclude-result-prefixes="#all">



  <!-- Convert a concept to an ISO19139 keywords.
    If no keyword is provided, only thesaurus section is adaded.
    -->
  <xsl:template name="to-iso19139-keyword-sinp">
    <xsl:param name="withAnchor" select="false()"/>
    <xsl:param name="withXlink" select="false()"/>
    <!-- Add thesaurus identifier using an Anchor which points to the download link.
        It's recommended to use it in order to have the thesaurus widget inline editor
        which use the thesaurus identifier for initialization. -->
    <xsl:param name="withThesaurusAnchor" select="true()"/>


    <!-- The lang parameter contains a list of languages
    with the main one as the first element. If only one element
    is provided, then CharacterString or Anchor are created.
    If more than one language is provided, then PT_FreeText
    with or without CharacterString can be created. -->
    <xsl:variable name="listOfLanguage" select="tokenize(/root/request/lang, ',')"/>
    <xsl:variable name="textgroupOnly"
                  as="xs:boolean"
                  select="if (/root/request/textgroupOnly and normalize-space(/root/request/textgroupOnly) != '')
                          then /root/request/textgroupOnly
                          else false()"/>


    <xsl:apply-templates mode="to-iso19139-keyword-sinp" select="." >
      <xsl:with-param name="withAnchor" select="$withAnchor"/>
      <xsl:with-param name="withXlink" select="$withXlink"/>
      <xsl:with-param name="withThesaurusAnchor" select="$withThesaurusAnchor"/>
      <xsl:with-param name="listOfLanguage" select="$listOfLanguage"/>
      <xsl:with-param name="textgroupOnly" select="$textgroupOnly"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="to-iso19139-keyword-sinp" match="*[not(/root/request/skipdescriptivekeywords)]">
    <xsl:param name="textgroupOnly"/>
    <xsl:param name="listOfLanguage"/>
    <xsl:param name="withAnchor"/>
    <xsl:param name="withXlink"/>
    <xsl:param name="withThesaurusAnchor"/>

    <sinp:descriptiveKeywords>
      <xsl:choose>
        <xsl:when test="$withXlink">
          <xsl:variable name="multiple"
                        select="if (contains(/root/request/id, ',')) then 'true' else 'false'"/>
          <xsl:variable name="isLocalXlink"
                        select="util:getSettingValue('system/xlinkResolver/localXlinkEnable')"/>
          <xsl:variable name="prefixUrl"
                        select="if ($isLocalXlink = 'true')
																then  concat('local://', /root/gui/language)
																else $serviceUrl"/>

          <xsl:attribute name="xlink:href"
                         select="concat($prefixUrl, '/xml.keyword.get?thesaurus=', thesaurus/key,
							                '&amp;amp;id=', replace(/root/request/id, '#', '%23'),
							                '&amp;amp;multiple=', $multiple,
							                if (/root/request/lang) then concat('&amp;amp;lang=', /root/request/lang) else '',
							                if ($textgroupOnly) then '&amp;amp;textgroupOnly' else '')"/>
          <xsl:attribute name="xlink:show">replace</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="to-md-keywords">
            <xsl:with-param name="withAnchor" select="$withAnchor"/>
            <xsl:with-param name="withThesaurusAnchor" select="$withThesaurusAnchor"/>
            <xsl:with-param name="listOfLanguage" select="$listOfLanguage"/>
            <xsl:with-param name="textgroupOnly" select="$textgroupOnly"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </sinp:descriptiveKeywords>
  </xsl:template>
</xsl:stylesheet>
