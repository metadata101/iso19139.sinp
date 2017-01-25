<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:gmd="http://www.isotc211.org/2005/gmd"
                xmlns:gts="http://www.isotc211.org/2005/gts"
                xmlns:gco="http://www.isotc211.org/2005/gco"
                xmlns:gmx="http://www.isotc211.org/2005/gmx"
                xmlns:srv="http://www.isotc211.org/2005/srv"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:gn="http://www.fao.org/geonetwork"
                xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
                xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
                xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
                xmlns:exslt="http://exslt.org/common"
                exclude-result-prefixes="#all">

  <xsl:include href="utility-tpl.xsl"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139.sinp" match="*|@*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template mode="mode-iso19139.sinp" match="sinp:*">
    <xsl:apply-templates mode="mode-iso19139" select=".">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Match codelist values. Must use iso19139.sinp because some
       19139 codelists are extended in mcp - if the codelist exists in
       iso19139.sinp then use that otherwise use iso19139 codelists
  -->
  <xsl:template mode="mode-iso19139"
                priority="30000"
                match="*[*/@codeList and
                         $schema = 'iso19139.sinp' and
                         name() != 'gmd:dateType']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>
    <xsl:param name="codelists" select="$schemaInfo/codelists" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

    <!-- check iso19139.sinp first, then fall back to iso19139 -->
    <xsl:variable name="listOfValues" as="node()">
      <xsl:variable name="profileCodeList" as="node()" select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $codelists, .)"/>
      <xsl:choose>
        <xsl:when test="count($profileCodeList/*) = 0"> <!-- do iso19139 -->
          <xsl:copy-of select="gn-fn-metadata:getCodeListValues('iso19139', name(*[@codeListValue]), $iso19139codelists, .)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$profileCodeList"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>


    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
                      select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
                      select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues" select="$listOfValues"/>
      <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>

  </xsl:template>




  <!-- Override default template to set transformation mode
  to to-iso19139-keyword-sinp. -->
  <xsl:template mode="mode-iso19139"
                match="sinp:descriptiveKeywords/gmd:MD_Keywords"
                priority="4000">

    <xsl:variable name="thesaurusIdentifier"
                  select="gmd:thesaurusName/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code"/>

    <xsl:variable name="thesaurusTitle"
                  select="gmd:thesaurusName/gmd:CI_Citation/gmd:title/(gco:CharacterString|gmd:PT_FreeText/gmd:textGroup/gmd:LocalisedCharacterString)"/>


    <xsl:variable name="thesaurusConfig"
                  as="element()?"
                  select="if ($thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier/*/text(), 'geonetwork.thesaurus.')])
                          then $thesaurusList/thesaurus[@key=substring-after($thesaurusIdentifier/*/text(), 'geonetwork.thesaurus.')]
                          else $listOfThesaurus/thesaurus[title=$thesaurusTitle]"/>

    <xsl:choose>
      <xsl:when test="$thesaurusConfig">

        <!-- The thesaurus key may be contained in the MD_Identifier field or
          get it from the list of thesaurus based on its title.
          -->
        <xsl:variable name="thesaurusInternalKey"
                      select="if ($thesaurusIdentifier)
                              then $thesaurusIdentifier
                              else $thesaurusConfig/key"/>
        <xsl:variable name="thesaurusKey"
                      select="if (starts-with($thesaurusInternalKey, 'geonetwork.thesaurus.'))
                              then substring-after($thesaurusInternalKey, 'geonetwork.thesaurus.')
                              else $thesaurusInternalKey"/>

        <!-- if gui lang eng > #EN -->
        <xsl:variable name="guiLangId"
                      select="
                      if (count($metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]) = 1)
                        then $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $lang]/@id
                        else $metadata/gmd:locale/gmd:PT_Locale[gmd:languageCode/gmd:LanguageCode/@codeListValue = $metadataLanguage]/@id"/>

        <xsl:variable name="keywords" select="string-join(
                  if ($guiLangId and gmd:keyword//*[@locale = concat('#', $guiLangId)])
                  then
                    gmd:keyword//*[@locale = concat('#', $guiLangId)]/replace(text(), ',', ',,')
                  else gmd:keyword/*[1]/replace(text(), ',', ',,'), ',')"/>

        <!-- Define the list of transformation mode available. -->
        <xsl:variable name="transformations"
                      as="xs:string"
                      select="'to-iso19139-keyword-sinp'"/>

        <!-- Get current transformation mode based on XML fragment analysis -->
        <xsl:variable name="transformation"
                      select="'to-iso19139-keyword-sinp'"/>


        <xsl:variable name="widgetMode" select="'tagsinput'"/>
        <xsl:variable name="maxTags"
                      as="xs:string"
                      select="if ($thesaurusConfig/@maxtags)
                              then $thesaurusConfig/@maxtags
                              else ''"/>
        <xsl:variable name="allLanguages" select="concat($metadataLanguage, ',', $metadataOtherLanguages)"></xsl:variable>
        <div data-gn-keyword-selector="{$widgetMode}"
             data-metadata-id="{$metadataId}"
             data-element-ref="{concat('_X', ../gn:element/@ref, '_replace')}"
             data-thesaurus-title="{$thesaurusTitle}"
             data-thesaurus-key="{$thesaurusKey}"
             data-keywords="{$keywords}" data-transformations="{$transformations}"
             data-current-transformation="{$transformation}"
             data-max-tags="{$maxTags}"
             data-lang="{$metadataOtherLanguagesAsJson}"
             data-textgroup-only="false">
        </div>

        <xsl:variable name="isTypePlace" select="count(gmd:type/gmd:MD_KeywordTypeCode[@codeListValue='place']) > 0"/>
        <xsl:if test="$isTypePlace">
          <xsl:call-template name="render-batch-process-button">
            <xsl:with-param name="process-name" select="'add-extent-from-geokeywords'"/>
            <xsl:with-param name="process-params">{"replace": true}</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="mode-iso19139" select="*"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
</xsl:stylesheet>
