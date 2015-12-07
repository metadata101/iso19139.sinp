<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sinpold="http://xml.sandre.eaufrance.fr/scenario/si_dc/3"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output indent="yes" method="xml"/>

  <xsl:template match="/">
    <xsl:apply-templates select="SI_DC/*" mode="sinp"/>
  </xsl:template>

  <xsl:template match="*" mode="sinp-contact">
    <xsl:param name="role" select="''" as="xs:string?"/>

    <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
      <xsl:if test="CdResponsable|CdIntervenant">
        <xsl:attribute name="uuid" select="CdResponsable|CdIntervenant"/>
      </xsl:if>
      <xsl:if test="NomResponsable">
        <gmd:individualName>
          <gco:CharacterString>
            <xsl:value-of select="NomResponsable"/>
          </gco:CharacterString>
        </gmd:individualName>
      </xsl:if>
      <gmd:organisationName>
        <gco:CharacterString>
          <xsl:value-of select="OrganismeResponsable|NomIntervenant"/>
        </gco:CharacterString>
      </gmd:organisationName>
      <!-- TODO?<gmd:positionName gco:nilReason="missing">
        <gco:CharacterString></gco:CharacterString>
      </gmd:positionName>-->
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <gmd:phone>
            <gmd:CI_Telephone>
              <gmd:voice>
                <gco:CharacterString>
                  <xsl:value-of select="Tel"/>
                </gco:CharacterString>
              </gmd:voice>
              <!--<gmd:facsimile gco:nilReason="missing">
                <gco:CharacterString/>
              </gmd:facsimile> TODO ?-->
            </gmd:CI_Telephone>
          </gmd:phone>
          <gmd:address>
            <gmd:CI_Address>
              <gmd:deliveryPoint>
                <gco:CharacterString>
                  <xsl:value-of select="RueResponsable|RueIntervenant"/>
                </gco:CharacterString>
              </gmd:deliveryPoint>
              <xsl:if test="LieuIntervenant">
                <gmd:deliveryPoint>
                  <gco:CharacterString>
                    <xsl:value-of select="LieuIntervenant"/>
                  </gco:CharacterString>
                </gmd:deliveryPoint>
              </xsl:if>
              <gmd:city>
                <gco:CharacterString>
                  <xsl:value-of select="VilleResponsable|VilleIntervenant"/>
                </gco:CharacterString>
              </gmd:city>
              <xsl:if test="DepIntervenant">
                <gmd:administrativeArea>
                  <gco:CharacterString>
                    <xsl:value-of select="DepIntervenant"/>
                  </gco:CharacterString>
                </gmd:administrativeArea>
              </xsl:if>
              <gmd:postalCode>
                <gco:CharacterString>
                  <xsl:value-of select="CPResponsable|BPIntervenant|CPIntervenant"/>
                </gco:CharacterString>
              </gmd:postalCode>
              <xsl:if test="Pays">
                <gmd:country>
                  <gco:CharacterString>
                    <xsl:value-of select="Pays"/>
                  </gco:CharacterString>
                </gmd:country>
              </xsl:if>
              <gmd:electronicMailAddress>
                <gco:CharacterString>
                  <xsl:value-of select="Mail"/>
                </gco:CharacterString>
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>
          <xsl:if test="URLWeb">
            <gmd:onlineResource>
              <gmd:CI_OnlineResource>
                <gmd:linkage>
                  <gmd:URL>
                    <xsl:value-of select="URLWeb"/>
                  </gmd:URL>
                </gmd:linkage>
              </gmd:CI_OnlineResource>
            </gmd:onlineResource>
          </xsl:if>
        </gmd:CI_Contact>
      </gmd:contactInfo>
      <gmd:role>
        <gmd:CI_RoleCode codeListValue="{if ($role != '') then $role else 'pointOfContact'}"
          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
        />
      </gmd:role>

      <!-- TODO -->
      <sinp:altIndividualName>
        <gco:CharacterString/>
      </sinp:altIndividualName>

      <!-- TODO Dans l'export SINP StIntervenant = A ? 
      LbStatut ? -->
      <xsl:variable name="statusMapping">
        <entry>
          <code>association</code>
          <label>Association</label>
        </entry>
        <entry>
          <code>collectivite-territoriale</code>
          <label>Collectivité territoriale</label>
        </entry>
        <entry>
          <code>entreprise</code>
          <label>Entreprise</label>
        </entry>
        <entry>
          <code>etablissement-public-de-l-etat</code>
          <label>Établissement public de l'État</label>
        </entry>
        <entry>
          <code>etablissement-public-regional</code>
          <label>Établissement public Régional</label>
        </entry>
        <entry>
          <code>etat</code>
          <label>État</label>
        </entry>
        <entry>
          <code>fondation</code>
          <label>Fondation</label>
        </entry>
        <entry>
          <code>gip</code>
          <label>Groupement d'Intérêt Public (GIP)</label>
        </entry>
        <entry>
          <code>gis</code>
          <label>Groupement d'Intérêt Scientifique (GIS)</label>
        </entry>
        <entry>
          <code>syndicat-mixte</code>
          <label>Syndicat Mixte</label>
        </entry>
        <entry>
          <code>ue</code>
          <label>Union Européenne</label>
        </entry>
        <entry>
          <code>univ-ees</code>
          <label>Université / établissement d’enseignement supérieur</label>
        </entry>
        <!-- TODO: ?
        Établissement public de l'État != Etablissement public de l'Etat
        On corrige -->
      </xsl:variable>

      <xsl:for-each select="LbStatut">
        <xsl:variable name="current" select="."/>
        <xsl:variable name="code" select="$statusMapping/entry/label[text() = $current]/code"/>
        
       <sinp:responsiblePartyStatus>
         <sinp:ResponsiblePartyStatusCode codeList="" 
           codeListValue="{if ($code != '') then $code else .}"/>
       </sinp:responsiblePartyStatus>
      </xsl:for-each>


      <xsl:for-each select="DepartementInt|RegionInt">
        <!-- TODO: Suffisant ? -->
        <sinp:extentDescription>
          <gco:CharacterString>
            <xsl:value-of select="LbDepartement|LbRegion"/>
          </gco:CharacterString>
        </sinp:extentDescription>
      </xsl:for-each>

      <!-- TODO Dans l'export SINP terreOuMerInt ? -->
      <sinp:scopeDescription>
        <sinp:ResponsiblePartyScopeCode codeList="" codeListValue="Mer"/>
      </sinp:scopeDescription>

      <xsl:for-each select="EvenementsInt">
        <sinp:history>
          <gmd:LI_ProcessStep>
            <gmd:description>
              <gco:CharacterString>
                <xsl:value-of select="LbEvenement"/>
              </gco:CharacterString>
            </gmd:description>
            <gmd:dateTime>
              <gco:DateTime>
                <xsl:value-of select="DateEvenement"/>
              </gco:DateTime>
            </gmd:dateTime>
          </gmd:LI_ProcessStep>
        </sinp:history>
      </xsl:for-each>
      <xsl:if test="CommentairesIntervenant">
        <sinp:description>
          <gco:CharacterString>
            <xsl:value-of select="CommentairesIntervenant"/>
          </gco:CharacterString>
        </sinp:description>
      </xsl:if>
      <!-- TODO -->
      <xsl:for-each select="TODO">
        <sinp:relatedResponsibleParty>
          <gco:CharacterString/>
        </sinp:relatedResponsibleParty>
      </xsl:for-each>
    </sinp:CI_ResponsibleParty>
  </xsl:template>


  <xsl:template match="Bdd" mode="sinp"> </xsl:template>

  <xsl:template match="DispositifCollecte" mode="sinp">
    <gmd:MD_Metadata>
      <gmd:fileIdentifier>
        <gco:CharacterString>
          <xsl:value-of select="IdEchangeRdd"/>
        </gco:CharacterString>
      </gmd:fileIdentifier>

      <!-- Metadata language is french -->
      <gmd:language>
        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/" codeListValue="fre"/>
      </gmd:language>

      <!-- Metadata character set is URF-8 -->
      <gmd:characterSet>
        <gmd:MD_CharacterSetCode codeListValue="utf8"
          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"
        />
      </gmd:characterSet>

      <!-- Hierarchy level is always dispositifDeCollecte
      Dans l'ancien export, series est utilisé. -->
      <gmd:hierarchyLevel>
        <gmd:MD_ScopeCode
          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode"
          codeListValue="dispositifDeCollecte"/>
      </gmd:hierarchyLevel>

      <xsl:for-each select="Responsable">
        <gmd:contact>
          <xsl:apply-templates select="." mode="sinp-contact"/>
        </gmd:contact>
      </xsl:for-each>
      <gmd:dateStamp>
        <gco:DateTime><xsl:value-of select="DateMajFicheRdd"/></gco:DateTime>
      </gmd:dateStamp>
      <gmd:metadataStandardName>
        <gco:CharacterString>ISO 19115:2003/19139 - Profil SINP</gco:CharacterString>
      </gmd:metadataStandardName>
      <gmd:metadataStandardVersion>
        <gco:CharacterString>1.0</gco:CharacterString>
      </gmd:metadataStandardVersion>
      
      <xsl:for-each select="CRS">
       <gmd:referenceSystemInfo>
         <gmd:MD_ReferenceSystem>
           <gmd:referenceSystemIdentifier>
             <gmd:RS_Identifier>
               <gmd:code>
                 <!-- TODO: Plus que le simple code ?-->
                 <gco:CharacterString><xsl:value-of select="CdCRS"/></gco:CharacterString>
               </gmd:code>
             </gmd:RS_Identifier>
           </gmd:referenceSystemIdentifier>
         </gmd:MD_ReferenceSystem>
       </gmd:referenceSystemInfo>
      </xsl:for-each>
      
      
      <gmd:identificationInfo>
        <gmd:MD_DataIdentification>
          <gmd:citation>
            <gmd:CI_Citation>
              <gmd:title>
                <gco:CharacterString>
                  <xsl:value-of select="NomRdd"/>
                </gco:CharacterString>
              </gmd:title>
              <gmd:alternateTitle>
                <gco:CharacterString>TODO: Quel est l'élément ?</gco:CharacterString>
              </gmd:alternateTitle>
              <!-- Date. Pour info, dans reseau261800, dans l'export XML ISO19115 
                une date de création 2010-01-01 est ajouté 
                alors qu'elle n'est pas dans l'export XML SINP. 
              
              A priori correspond à AnneeMisePlaceRdd
              -->
              <xsl:if test="AnneeMisePlaceRdd">
                <gmd:date>
                  <gmd:CI_Date>
                    <gmd:date>
                      <gco:Date><xsl:value-of select="AnneeMisePlaceRdd"/>-01-01</gco:Date>
                    </gmd:date>
                    <gmd:dateType>
                      <gmd:CI_DateTypeCode
                        codeList="http://www.isotc211.org/2005/resources/codeList.xml#CI_DateTypeCode"
                        codeListValue="creation"/>
                    </gmd:dateType>
                  </gmd:CI_Date>
                </gmd:date>
              </xsl:if>
              <gmd:identifier>
                <gmd:MD_Identifier>
                  <gmd:code>
                    <gco:CharacterString>
                      <xsl:value-of select="IdEchangeRdd"/>
                    </gco:CharacterString>
                  </gmd:code>
                </gmd:MD_Identifier>
              </gmd:identifier>
              <!--
              Dans l'ancien export le champ presentationForm est utilisé
              -->
            </gmd:CI_Citation>
          </gmd:citation>
          <gmd:abstract>
            <gco:CharacterString>
              <xsl:value-of select="DescriptionFinaliteRdd"/>
            </gco:CharacterString>
          </gmd:abstract>
          <!-- TODO: Objectifs scientifiques -->
          <gmd:purpose>
            <gco:CharacterString/>
          </gmd:purpose>
          <!-- TODO: Non utilisé ? 
            Dans l'ancien export completed semble utilisé
            
            EtatActivite ?
            
          <gmd:status>
            <gmd:MD_ProgressCode codeListValue="completed"
              codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ProgressCode"
            />
          </gmd:status>
          -->

          <xsl:variable name="roleMapping">
            <value key="MOU">originator</value>
            <!-- TODO : vérifier key -->
            <value key="MOE">principalInvestigator</value>
            <!-- TODO : vérifier key -->
            <value key="FIN">owner</value>
            <value key="POC">pointOfContact</value>
            <!-- Ce cas n'est pas dans le nouveau profil ? Il y a des cas dans l'ancien export
            avec une valeur incorrecte PrRecueilocessor au lieu de processor-->
            <value key="COL">processor</value>
          </xsl:variable>
          <xsl:for-each select="IntervenantRdd/Intervenant">
            <xsl:variable name="code" select="CdIntervenant"/>
            <xsl:variable name="role" select="@Role"/>
            <gmd:pointOfContact>
              <xsl:apply-templates mode="sinp-contact"
                select="/SI_DC/Intervenant[CdIntervenant = $code]">
                <xsl:with-param name="role" select="$roleMapping/value[@key = $role]/text()"/>
              </xsl:apply-templates>
            </gmd:pointOfContact>
          </xsl:for-each>


          <!-- TODO: -->
          <gmd:resourceMaintenance>
            <gmd:MD_MaintenanceInformation>
              <gmd:maintenanceAndUpdateFrequency>
                <gmd:MD_MaintenanceFrequencyCode codeListValue="asNeeded"
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                />
              </gmd:maintenanceAndUpdateFrequency>
              <xsl:for-each select="DureeRdd/LbDuree">
               <gmd:maintenanceNote>
                 <gco:CharacterString>
                   <xsl:value-of select="."/>
                 </gco:CharacterString>
               </gmd:maintenanceNote>
              </xsl:for-each>
            </gmd:MD_MaintenanceInformation>
          </gmd:resourceMaintenance>

          <xsl:if test="terre_ou_mer">
           <gmd:descriptiveKeywords>
             <gmd:MD_Keywords>
               <gmd:keyword>
                 <gco:CharacterString>
                   <!-- TODO: Vérifier -->
                   <xsl:value-of select="if (terre_ou_mer = 'T') then 'Terre' 
                                         else if (terre_ou_mer = 'M') then 'Mer' 
                                         else 'Paysage'"></xsl:value-of>
                 </gco:CharacterString>
               </gmd:keyword>
               <gmd:type>
                 <gmd:MD_KeywordTypeCode
                   codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                   codeListValue="theme"/>
               </gmd:type>
               <gmd:thesaurusName>
                 <gmd:CI_Citation>
                   <gmd:title>
                     <gco:CharacterString>Volet SINP</gco:CharacterString>
                   </gmd:title>
                   <gmd:date>
                     <gmd:CI_Date>
                       <gmd:date>
                         <gco:Date>2015-11-27</gco:Date>
                       </gmd:date>
                       <gmd:dateType>
                         <gmd:CI_DateTypeCode
                           codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                           codeListValue="publication"/>
                       </gmd:dateType>
                     </gmd:CI_Date>
                   </gmd:date>
                   <gmd:identifier>
                     <gmd:MD_Identifier>
                       <gmd:code>
                         <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                           xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-volet"
                           >geonetwork.thesaurus.external.theme.sinp-volet</gmx:Anchor>
                       </gmd:code>
                     </gmd:MD_Identifier>
                   </gmd:identifier>
                 </gmd:CI_Citation>
               </gmd:thesaurusName>
             </gmd:MD_Keywords>
           </gmd:descriptiveKeywords>
          </xsl:if>

          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:type>
                <gmd:MD_KeywordTypeCode
                  codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                  codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Type de dispositif SINP</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2015-11-27</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                          xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-de-dispositif"
                          >geonetwork.thesaurus.external.theme.sinp-type-de-dispositif</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:type>
                <gmd:MD_KeywordTypeCode
                  codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                  codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Niveau territorial</gco:CsharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2015-11-27</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                          xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-niveau-territorial"
                          >geonetwork.thesaurus.external.theme.sinp-niveau-territorial</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <xsl:for-each select="RegionRdd">
                <gmd:keyword>
                  <gco:CharacterString>
                    <xsl:value-of select="LbRegion"/>
                  </gco:CharacterString>
                </gmd:keyword>
              </xsl:for-each>
              <gmd:type>
                <gmd:MD_KeywordTypeCode codeList="" codeListValue="place"/>
              </gmd:type>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:keyword>
                <gco:CharacterString>Type d’espace concerné - A préciser</gco:CharacterString>
              </gmd:keyword>
              <gmd:type>
                <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme"/>
              </gmd:type>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <!--
            TODO: Que faire du type, code ?
          <descriptiveKeywords>
            <MD_Keywords>
              <keyword>INSECTE</keyword>
              <type>environnement</type>
              <codeMotCle>http://rdfdata.eionet.europa.eu/sidetheme#2309</codeMotCle>
            </MD_Keywords>
          </descriptiveKeywords>
          -->
          <xsl:if test="count(descriptiveKeywords) > 0">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="descriptiveKeywords">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="MD_Keywords/keyword"/>
                    </gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme"/>
                </gmd:type>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:type>
                <gmd:MD_KeywordTypeCode
                  codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                  codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Type de financement</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2015-11-27</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                          xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-de-financement"
                          >geonetwork.thesaurus.external.theme.sinp-type-de-financement</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:type>
                <gmd:MD_KeywordTypeCode
                  codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                  codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Plan d'échantillonnage</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2015-11-27</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                          xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-plan-d-echantillonnage"
                          >geonetwork.thesaurus.external.theme.sinp-plan-d-echantillonnage</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          <gmd:descriptiveKeywords>
            <gmd:MD_Keywords>
              <gmd:type>
                <gmd:MD_KeywordTypeCode
                  codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                  codeListValue="theme"/>
              </gmd:type>
              <gmd:thesaurusName>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Méthode de recueil</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date>2015-11-27</gco:Date>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue="publication"/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                          xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-methode-de-recueil"
                          >geonetwork.thesaurus.external.theme.sinp-methode-de-recueil</gmx:Anchor>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:thesaurusName>
            </gmd:MD_Keywords>
          </gmd:descriptiveKeywords>
          
          <xsl:if test="RefMilieux">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="RefMilieux">
                  <!-- TODO: Devons nous vérifier que les valeurs sont bien dans le thésaurus ? -->
                  <gmd:keyword>
                    <gco:CharacterString><xsl:value-of select="LbRefMetier"/></gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode
                    codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                    codeListValue="theme"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>Référentiels Milieux</gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2015-11-27</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode
                            codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                            codeListValue="publication"/>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                    <gmd:identifier>
                      <gmd:MD_Identifier>
                        <gmd:code>
                          <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                            xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-milieux"
                            >geonetwork.thesaurus.external.theme.sinp-referentiels-milieux</gmx:Anchor>
                        </gmd:code>
                      </gmd:MD_Identifier>
                    </gmd:identifier>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>

          <xsl:if test="RefTaxons">
           <gmd:descriptiveKeywords>
             <gmd:MD_Keywords>
               <xsl:for-each select="RefTaxons">
                 <gmd:keyword>
                   <gco:CharacterString><xsl:value-of select="LbRefMetier"/></gco:CharacterString>
                 </gmd:keyword>
               </xsl:for-each>
               <gmd:type>
                 <gmd:MD_KeywordTypeCode
                   codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                   codeListValue="theme"/>
               </gmd:type>
               <gmd:thesaurusName>
                 <gmd:CI_Citation>
                   <gmd:title>
                     <gco:CharacterString>Référentiels taxonomiques</gco:CharacterString>
                   </gmd:title>
                   <gmd:date>
                     <gmd:CI_Date>
                       <gmd:date>
                         <gco:Date>2015-11-27</gco:Date>
                       </gmd:date>
                       <gmd:dateType>
                         <gmd:CI_DateTypeCode
                           codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                           codeListValue="publication"/>
                       </gmd:dateType>
                     </gmd:CI_Date>
                   </gmd:date>
                   <gmd:identifier>
                     <gmd:MD_Identifier>
                       <gmd:code>
                         <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                           xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-taxonomiques"
                           >geonetwork.thesaurus.external.theme.sinp-referentiels-taxonomiques</gmx:Anchor>
                       </gmd:code>
                     </gmd:MD_Identifier>
                   </gmd:identifier>
                 </gmd:CI_Citation>
               </gmd:thesaurusName>
             </gmd:MD_Keywords>
           </gmd:descriptiveKeywords>
          </xsl:if>

          <xsl:if test="RefGeographiques">
           <gmd:descriptiveKeywords>
             <gmd:MD_Keywords>
               <!-- TODO: Devons nous vérifier que les valeurs sont bien dans le thésaurus ? -->
               <xsl:for-each select="RefGeographiques">
                 <gmd:keyword>
                   <gco:CharacterString><xsl:value-of select="LbRefMetier"/></gco:CharacterString>
                 </gmd:keyword>
               </xsl:for-each>
               <gmd:type>
                 <gmd:MD_KeywordTypeCode
                   codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                   codeListValue="theme"/>
               </gmd:type>
               <gmd:thesaurusName>
                 <gmd:CI_Citation>
                   <gmd:title>
                     <gco:CharacterString>Référentiels géographiques</gco:CharacterString>
                   </gmd:title>
                   <gmd:date>
                     <gmd:CI_Date>
                       <gmd:date>
                         <gco:Date>2015-11-27</gco:Date>
                       </gmd:date>
                       <gmd:dateType>
                         <gmd:CI_DateTypeCode
                           codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                           codeListValue="publication"/>
                       </gmd:dateType>
                     </gmd:CI_Date>
                   </gmd:date>
                   <gmd:identifier>
                     <gmd:MD_Identifier>
                       <gmd:code>
                         <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                           xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-referentiels-geographiques"
                           >geonetwork.thesaurus.external.theme.sinp-referentiels-geographiques</gmx:Anchor>
                       </gmd:code>
                     </gmd:MD_Identifier>
                   </gmd:identifier>
                 </gmd:CI_Citation>
               </gmd:thesaurusName>
             </gmd:MD_Keywords>
           </gmd:descriptiveKeywords>
          </xsl:if>

          <!-- Jeu de données uniquement -->
          <xsl:for-each select="ModeStockageRdd/LbModeStockage">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <gmd:keyword>
                  <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                </gmd:keyword>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                    codeListValue="theme"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>Mode de stockage</gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2015-11-27</gco:Date>
                        </gmd:date>
                        <gmd:dateType>
                          <gmd:CI_DateTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                            codeListValue="publication"/>
                        </gmd:dateType>
                      </gmd:CI_Date>
                    </gmd:date>
                    <gmd:identifier>
                      <gmd:MD_Identifier>
                        <gmd:code>
                          <gmx:Anchor xmlns:gmx="http://www.isotc211.org/2005/gmx"
                            xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-stockage">geonetwork.thesaurus.external.theme.sinp-stockage</gmx:Anchor>
                        </gmd:code>
                      </gmd:MD_Identifier>
                    </gmd:identifier>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:for-each>
          
          
          <gmd:resourceConstraints>
            <gmd:MD_LegalConstraints>
              <gmd:accessConstraints>
                <gmd:MD_RestrictionCode codeListValue="copyright"
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
                />
              </gmd:accessConstraints>
              <gmd:useConstraints>
                <gmd:MD_RestrictionCode codeListValue="otherRestictions"
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_RestrictionCode"
                />
              </gmd:useConstraints>
              <gmd:otherConstraints gco:nilReason="missing">
                <gco:CharacterString>
                  <!-- TODO: Vérifier ? -->
                  <xsl:value-of select="AccesDonneesRdd/LbAcces"/>
                </gco:CharacterString>
              </gmd:otherConstraints>
            </gmd:MD_LegalConstraints>
          </gmd:resourceConstraints>
          <xsl:for-each select="LanguesDonnees">
            <gmd:language>
              <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                codeListValue="{if (CdLangue = 'fra') then 'fre' else CdLangue}"/>
            </gmd:language>
          </xsl:for-each>


          <xsl:variable name="topicCategoryMapping">
            <value key="Flore et faune">biota</value>
            <!-- TODO other values -->
          </xsl:variable>
          <xsl:for-each select="Thematique19115">
            <xsl:variable name="current" select="LbThematique19115"/>
            <gmd:topicCategory>
              <gmd:MD_TopicCategoryCode>
                <xsl:value-of select="$topicCategoryMapping/value[@key = $current]/text()"/>
              </gmd:MD_TopicCategoryCode>
            </gmd:topicCategory>
          </xsl:for-each>


          <xsl:for-each select="ExtentRdd">
            <gmd:extent>
              <gmd:EX_Extent>
                <gmd:geographicElement>
                  <gmd:EX_GeographicBoundingBox>
                    <gmd:westBoundLongitude>
                      <gco:Decimal><xsl:value-of select="xmin"/></gco:Decimal>
                    </gmd:westBoundLongitude>
                    <gmd:eastBoundLongitude>
                      <gco:Decimal><xsl:value-of select="xmax"/></gco:Decimal>
                    </gmd:eastBoundLongitude>
                    <gmd:southBoundLatitude>
                      <gco:Decimal><xsl:value-of select="ymin"/></gco:Decimal>
                    </gmd:southBoundLatitude>
                    <gmd:northBoundLatitude>
                      <gco:Decimal><xsl:value-of select="ymax"/></gco:Decimal>
                    </gmd:northBoundLatitude>
                  </gmd:EX_GeographicBoundingBox>
                </gmd:geographicElement>
              </gmd:EX_Extent>
            </gmd:extent>
          </xsl:for-each>
          
          
          <gmd:extent>
            <gmd:EX_Extent>
              <gmd:description>
                <gco:CharacterString>Emprise réelle et effective du territoire
                  couvert</gco:CharacterString>
              </gmd:description>
              <gmd:temporalElement>
                <gmd:EX_TemporalExtent>
                  <gmd:extent>
                    <gml:TimePeriod gml:id="d16032e284a1052958">
                      <gml:beginPosition/>
                      <gml:endPosition/>
                    </gml:TimePeriod>
                  </gmd:extent>
                </gmd:EX_TemporalExtent>
              </gmd:temporalElement>
            </gmd:EX_Extent>
          </gmd:extent>
          
          <xsl:for-each select="CommentairesRdd">
           <gmd:supplementalInformation>
             <gco:CharacterString>
               <xsl:value-of select="."/>
             </gco:CharacterString>
           </gmd:supplementalInformation>
          </xsl:for-each>
        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>
      <gmd:distributionInfo>
        <gmd:MD_Distribution>
          <gmd:transferOptions>
            <gmd:MD_DigitalTransferOptions>
              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL/>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>WWW:LINK-1.0-http--link</gco:CharacterString>
                  </gmd:protocol>
                  <gmd:name gco:nilReason="missing">
                    <gco:CharacterString/>
                  </gmd:name>
                  <gmd:description gco:nilReason="missing">
                    <gco:CharacterString/>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>
              <gmd:onLine>
                <gmd:CI_OnlineResource>
                  <gmd:linkage>
                    <gmd:URL/>
                  </gmd:linkage>
                  <gmd:protocol>
                    <gco:CharacterString>OGC:WMS-1.1.1-http-get-map</gco:CharacterString>
                  </gmd:protocol>
                  <gmd:name gco:nilReason="missing">
                    <gco:CharacterString/>
                  </gmd:name>
                  <gmd:description gco:nilReason="missing">
                    <gco:CharacterString/>
                  </gmd:description>
                </gmd:CI_OnlineResource>
              </gmd:onLine>
            </gmd:MD_DigitalTransferOptions>
          </gmd:transferOptions>
        </gmd:MD_Distribution>
      </gmd:distributionInfo>
      <gmd:dataQualityInfo>
        <gmd:DQ_DataQuality>
          <gmd:scope>
            <gmd:DQ_Scope>
              <gmd:level>
                <gmd:MD_ScopeCode codeListValue="dataset"
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode"
                />
              </gmd:level>
            </gmd:DQ_Scope>
          </gmd:scope>
          <gmd:report>
            <gmd:DQ_DomainConsistency>
              <gmd:evaluationMethodType>
                <gmd:DQ_EvaluationMethodTypeCode
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#DQ_EvaluationMethodTypeCode"
                  codeListValue="directInternal"/>
              </gmd:evaluationMethodType>
              <gmd:evaluationMethodDescription gco:nilReason="missing">
                <gco:CharacterString/>
              </gmd:evaluationMethodDescription>
              <gmd:evaluationProcedure>
                <gmd:CI_Citation>
                  <gmd:title>
                    <gco:CharacterString>Méthode de validation</gco:CharacterString>
                  </gmd:title>
                  <gmd:date>
                    <gmd:CI_Date>
                      <gmd:date>
                        <gco:Date/>
                      </gmd:date>
                      <gmd:dateType>
                        <gmd:CI_DateTypeCode
                          codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_DateTypeCode"
                          codeListValue=""/>
                      </gmd:dateType>
                    </gmd:CI_Date>
                  </gmd:date>
                  <gmd:identifier>
                    <gmd:MD_Identifier>
                      <gmd:code>
                        <gco:CharacterString>URL du protocol ?</gco:CharacterString>
                      </gmd:code>
                    </gmd:MD_Identifier>
                  </gmd:identifier>
                </gmd:CI_Citation>
              </gmd:evaluationProcedure>
            </gmd:DQ_DomainConsistency>
          </gmd:report>
          <gmd:lineage>
            <gmd:LI_Lineage>
              <gmd:statement gco:nilReason="missing">
                <gco:CharacterString/>
              </gmd:statement>
              <xsl:for-each select="HistoriqueEvtsRdd">
                <xsl:sort select="DtHistoriqueEvtsRdd" order="descending"/>
                <gmd:processStep>
                  <gmd:LI_ProcessStep>
                    <gmd:description>
                      <gco:CharacterString>
                        <xsl:value-of select="DesHistoriqueEvtsRdd"/>
                      </gco:CharacterString>
                    </gmd:description>
                    <gmd:dateTime>
                      <gco:DateTime>
                        <xsl:value-of select="DtHistoriqueEvtsRdd"/>
                      </gco:DateTime>
                    </gmd:dateTime>
                    <!-- TODO: AuteurHistoriqueEvtsRdd ? -->
                  </gmd:LI_ProcessStep>
                </gmd:processStep>
              </xsl:for-each>
            </gmd:LI_Lineage>
          </gmd:lineage>
        </gmd:DQ_DataQuality>
      </gmd:dataQualityInfo>
    </gmd:MD_Metadata>
  </xsl:template>
  <xsl:template match="*" mode="sinp"/>
</xsl:stylesheet>
