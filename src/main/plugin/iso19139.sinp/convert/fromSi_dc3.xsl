<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:sinpold="http://xml.sandre.eaufrance.fr/scenario/si_dc/3"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml"
  xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:sinp="http://inventaire.naturefrance.fr/schemas/2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:output indent="yes" method="xml"/>


  <xsl:variable name="topicCategoryMapping">
    <value key="Flore et faune">biota</value>
    <!-- TODO other values ? -->
  </xsl:variable>


  <xsl:variable name="roleMapping">
    <value key="MOU">originator</value>
    <value key="MOE">principalInvestigator</value>
    <value key="FIN">owner</value>
    <value key="POC">pointOfContact</value>
    <!-- Ce cas n'est pas dans le nouveau profil ? Il y a des cas dans l'ancien export
    avec une valeur incorrecte PrRecueilocessor au lieu de processor-->
    <value key="COL">processor</value>
  </xsl:variable>



  <xsl:template match="/">
    <xsl:apply-templates select="SI_DC/*" mode="sinp"/>
  </xsl:template>



  <!--
  TODOXSD
<xs:element name="Intervenant" minOccurs="0" maxOccurs="unbounded" nillable="false">
  <xs:complexType mixed="false">
      <xs:sequence minOccurs="1" maxOccurs="1">
          <xs:element name="DateCreationIntervenant" type="sa_int:DateCreationIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="DateMajIntervenant" type="sa_int:DateMajIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="AuteurIntervenant" type="sa_int:AuteurIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="ImmoIntervenant" type="sa_int:ImmoIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="ActivitesIntervenant" type="sa_int:ActivitesIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="NomInternationalIntervenant" type="sa_int:NomInternationalIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="CdSIRETRattacheIntervenant" type="sa_int:CdSIRETRattacheIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
          <xs:element name="IdEchangeInt" type="sa_bp:IdEchangeInt" minOccurs="1" maxOccurs="1" nillable="false"/>
          sinp:relatedResponsibleParty ?
          <xs:element name="StructureMere" minOccurs="0" maxOccurs="1" nillable="false">
              <xs:complexType mixed="false">
                  <xs:sequence minOLbTypeRddccurs="1" maxOccurs="1">
                      <xs:element name="CdIntervenant" type="sa_int:CdIntervenant" minOccurs="1" maxOccurs="1" nillable="false"/>
                      <xs:element name="IdEchangeInt" type="sa_bp:IdEchangeInt" minOccurs="1" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
   -->
  <xsl:template match="*" mode="sinp-contact">
    <xsl:param name="role" select="''" as="xs:string?"/>

    <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
      <!--
      <xs:element name="CdIntervenant" type="sa_int:CdIntervenant" minOccurs="1" maxOccurs="1" nillable="false"/>
      -->
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
      <!--
      <xs:element name="NomIntervenant" type="sa_int:NomIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <gmd:organisationName>
        <gco:CharacterString>
          <xsl:value-of select="OrganismeResponsable|NomIntervenant"/>
        </gco:CharacterString>
      </gmd:organisationName>

      <xsl:for-each select="ServiceResponsable[. != '']">
        <gmd:positionName>
          <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
        </gmd:positionName>
      </xsl:for-each>
      <gmd:contactInfo>
        <gmd:CI_Contact>
          <!--
          <xs:element name="Tel" type="sinp:Tel" minOccurs="0" maxOccurs="1" nillable="false"/>
          -->
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
              <!--
              <xs:element name="RueIntervenant" type="sa_int:RueIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <gmd:deliveryPoint>
                <gco:CharacterString>
                  <xsl:value-of select="RueResponsable|RueIntervenant"/>
                </gco:CharacterString>
              </gmd:deliveryPoint>
              <!--
              <xs:element name="LieuIntervenant" type="sa_int:LieuIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <xsl:if test="LieuIntervenant">
                <gmd:deliveryPoint>
                  <gco:CharacterString>
                    <xsl:value-of select="LieuIntervenant"/>
                  </gco:CharacterString>
                </gmd:deliveryPoint>
              </xsl:if>
              <!--
              <xs:element name="VilleIntervenant" type="sa_int:VilleIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <gmd:city>
                <gco:CharacterString>
                  <xsl:value-of select="VilleResponsable|VilleIntervenant"/>
                </gco:CharacterString>
              </gmd:city>
              <!--
              <xs:element name="DepIntervenant" type="sa_int:DepIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <xsl:if test="DepIntervenant">
                <gmd:administrativeArea>
                  <gco:CharacterString>
                    <xsl:value-of select="DepIntervenant"/>
                  </gco:CharacterString>
                </gmd:administrativeArea>
              </xsl:if>
              <!--
              <xs:element name="BpIntervenant" type="sa_int:BpIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              <xs:element name="CPIntervenant" type="sa_int:CPIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <gmd:postalCode>
                <gco:CharacterString>
                  <xsl:value-of select="CPResponsable|BPIntervenant|CPIntervenant"/>
                </gco:CharacterString>
              </gmd:postalCode>
              <!--
              <xs:element name="Pays" type="sinp:Pays" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <xsl:if test="Pays">
                <gmd:country>
                  <gco:CharacterString>
                    <xsl:value-of select="Pays"/>
                  </gco:CharacterString>
                </gmd:country>
              </xsl:if>
              <!--
              <xs:element name="Mail" type="sinp:Mail" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <gmd:electronicMailAddress>
                <gco:CharacterString>
                  <xsl:value-of select="Mail"/>
                </gco:CharacterString>
              </gmd:electronicMailAddress>
            </gmd:CI_Address>
          </gmd:address>

          <!--
          <xs:element name="URLWeb" type="sinp:URLWeb" minOccurs="0" maxOccurs="1" nillable="false"/>
          -->
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

      <!--
     <xs:element name="MnIntervenant" type="sa_int:MnIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <xsl:for-each select="MnIntervenant">
        <sinp:altIndividualName>
          <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
        </sinp:altIndividualName>
      </xsl:for-each>

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

      <!--
      <xs:element name="Statut" type="sinp:Statut" minOccurs="0" maxOccurs="1" nillable="false"/>

      Eg.
      <Statut>4</Statut>
      <LbStatut>Etablissement public de l'Etat</LbStatut>
      -->
      <xsl:for-each select="LbStatut">
        <xsl:variable name="current" select="normalize-space(.)"/>
        <xsl:variable name="code" select="$statusMapping/entry[label/text() = $current]/code"/>

       <sinp:responsiblePartyStatus>
         <sinp:ResponsiblePartyStatusCode codeList=""
           codeListValue="{if ($code != '') then $code else .}"/>
       </sinp:responsiblePartyStatus>
      </xsl:for-each>


      <!--
      <xs:element name="DepartementInt" minOccurs="0" maxOccurs="unbounded" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="CdDepartement" type="sa_com:CdDepartement" minOccurs="1" maxOccurs="1" nillable="false"/>
            <xs:element name="LbDepartement" type="sa_com:LbDepartement" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
        </xs:element>
        <xs:element name="RegionInt" minOccurs="0" maxOccurs="unbounded" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="CdRegion" type="sa_com:CdRegion" minOccurs="1" maxOccurs="1" nillable="false"/>
            <xs:element name="LbRegion" type="sa_com:LbRegion" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      -->
      <xsl:for-each select="DepartementInt|RegionInt">
        <sinp:extentDescription>
          <gco:CharacterString>
            <xsl:value-of select="LbDepartement|LbRegion"/>
          </gco:CharacterString>
        </sinp:extentDescription>
      </xsl:for-each>
      <xsl:for-each select="RegionResponsable">
        <sinp:extentDescription>
          <gco:CharacterString>
            <xsl:value-of select="."/>
          </gco:CharacterString>
        </sinp:extentDescription>
      </xsl:for-each>


      <!-- TODO Dans l'export SINP terreOuMerInt ? -->
      <xsl:for-each select="terreOuMerInt[. != '']">
       <sinp:scopeDescription>
         <sinp:ResponsiblePartyScopeCode codeList=""
              codeListValue="{if (. = 'T') then 'Terre' else 'Mer'}"/>
       </sinp:scopeDescription>
      </xsl:for-each>

      <!--
      <xs:element name="EvenementsInt" minOccurs="0" maxOccurs="unbounded" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="DateEvenement" type="sa_dc:DateEvenement" minOccurs="0" maxOccurs="1" nillable="false"/>
            <xs:element name="LbEvenement" type="sa_dc:LbEvenement" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      -->
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


      <!--
      <xs:element name="CommentairesIntervenant" type="sa_int:CommentairesIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <xsl:for-each select="CommentairesIntervenant[. != '']">
        <sinp:description>
          <gco:CharacterString>
            <xsl:value-of select="."/>
          </gco:CharacterString>
        </sinp:description>
      </xsl:for-each>
      <!-- TODO -->
      <xsl:for-each select="TODO">
        <sinp:relatedResponsibleParty>
          <gco:CharacterString/>
        </sinp:relatedResponsibleParty>
      </xsl:for-each>
    </sinp:CI_ResponsibleParty>
  </xsl:template>


  <xsl:template match="Bdd"
                mode="sinp"/>


  <xsl:template match="DispositifCollecte"
                mode="sinp">
    <!--


    -->
    <gmd:MD_Metadata>
      <!--
      <xs:element name="IdEchangeRdd" type="sa_bp:IdEchangeRdd" minOccurs="1" maxOccurs="1" nillable="false"/>
      -->
      <gmd:fileIdentifier>
        <gco:CharacterString>urn:idcnp:<xsl:value-of select="IdEchangeRdd"/></gco:CharacterString>
      </gmd:fileIdentifier>


      <!-- TODOXSD : Pas dans le schéma ? -->
      <xsl:for-each select="DispositifAssocie/IdReseauPere[. != '']">
       <gmd:parentIdentifier>
         <gco:CharacterString>urn:idcnp:<xsl:value-of select="."/></gco:CharacterString>
       </gmd:parentIdentifier>
      </xsl:for-each>

      <!-- Metadata language is french -->
      <gmd:language>
        <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                          codeListValue="fre"/>
      </gmd:language>

      <!-- Metadata character set is URF-8 -->
      <gmd:characterSet>
        <gmd:MD_CharacterSetCode codeListValue="utf8"
                                 codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_CharacterSetCode"/>
      </gmd:characterSet>

      <!-- Hierarchy level is always collectionSystem
      Dans l'ancien export, series est utilisé. -->
      <gmd:hierarchyLevel>
        <gmd:MD_ScopeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ScopeCode"
                          codeListValue="collectionSystem"/>
      </gmd:hierarchyLevel>

      <!--
      <xs:element name="TypeRdd" minOccurs="0" maxOccurs="1" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="CdTypeRdd" type="sa_dc:CdTypeRdd" minOccurs="1" maxOccurs="1" nillable="false"/>
            <xs:element name="LbTypeRdd" type="sa_dc:LbTypeRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
        Valeurs possibles :
        ‘1’ : Réseau de mesure
        ‘2’ : Autres dispositifs
        ‘3’ : Autosurveillance
      </xs:element>
      -->
      <xsl:for-each select="TypeRdd/LbTypeRdd">
        <gmd:hierarchyLevelName>
          <gco:CharacterString>
            <xsl:value-of select="."/>
          </gco:CharacterString>
        </gmd:hierarchyLevelName>
      </xsl:for-each>

      <xsl:for-each select="Responsable">
        <gmd:contact>
          <xsl:apply-templates select="."
                               mode="sinp-contact"/>
        </gmd:contact>
      </xsl:for-each>

      <!--
      <xs:element name="DateMajFicheRdd" type="sa_dc:DateMajFicheRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <gmd:dateStamp>
        <gco:DateTime><xsl:value-of select="DateMajFicheRdd"/></gco:DateTime>
      </gmd:dateStamp>


      <gmd:metadataStandardName>
        <gco:CharacterString>ISO 19115:2003/19139 - Profil SINP</gco:CharacterString>
      </gmd:metadataStandardName>
      <gmd:metadataStandardVersion>
        <gco:CharacterString>1.0</gco:CharacterString>
      </gmd:metadataStandardVersion>


      <!--
      <xs:element name="NbTotalRdd" type="sa_dc:NbTotalRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <xsl:for-each select="NbTotalRdd">
        <gmd:spatialRepresentationInfo>
          <gmd:MD_VectorSpatialRepresentation>
            <gmd:geometricObjects>
              <gmd:MD_GeometricObjects>
                <gmd:geometricObjectType>
                  <gmd:MD_GeometricObjectTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_GeometricObjectTypeCode"
                                                  codeListValue="point"/>
                </gmd:geometricObjectType>
                <gmd:geometricObjectCount>
                  <gco:Integer><xsl:value-of select="NbTotalRdd"/></gco:Integer>
                </gmd:geometricObjectCount>
              </gmd:MD_GeometricObjects>
            </gmd:geometricObjects>
          </gmd:MD_VectorSpatialRepresentation>
        </gmd:spatialRepresentationInfo>
      </xsl:for-each>


      <!--
      <xs:element name="CRS" minOccurs="0" maxOccurs="unbounded" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="CdCRS" type="xs:string" minOccurs="1" maxOccurs="1" nillable="false"/>
            <xs:element name="LbCRS" type="xs:string" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      -->
      <xsl:for-each select="CRS">
       <gmd:referenceSystemInfo>
         <gmd:MD_ReferenceSystem>
           <gmd:referenceSystemIdentifier>
             <gmd:RS_Identifier>
               <gmd:code>
                 <gco:CharacterString><xsl:value-of select="CdCRS"/></gco:CharacterString>
               </gmd:code>
               <gmd:codeSpace>
                 <gco:CharacterString>
                   <xsl:value-of select="epsg"/>
                 </gco:CharacterString>
               </gmd:codeSpace>
             </gmd:RS_Identifier>
           </gmd:referenceSystemIdentifier>
         </gmd:MD_ReferenceSystem>
       </gmd:referenceSystemInfo>
      </xsl:for-each>

      <!--
      OLD
				<xsl:for-each select="DispositifCollecte/RefGeographiques/LbRefMetier">
					<xsl:call-template name="referenceSystemInfo">
						<xsl:with-param name="code" select="."/>
						<xsl:with-param name="codeSpace">geographic</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:for-each select="DispositifCollecte/CRS/CdCRS">
					<xsl:call-template name="directReferenceSystemInfo">
						<xsl:with-param name="code" select="."/>
						<xsl:with-param name="codeSpace">epsg</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:for-each select="DispositifCollecte/RefMilieux/LbRefMetier">
					<xsl:call-template name="referenceSystemInfo">
						<xsl:with-param name="code" select="."/>
						<xsl:with-param name="codeSpace">milieu</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<xsl:for-each select="DispositifCollecte/RefTaxons/LbRefMetier">
					<xsl:call-template name="referenceSystemInfo">
						<xsl:with-param name="code" select="."/>
						<xsl:with-param name="codeSpace">taxon</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

      -->

      <gmd:identificationInfo>
        <gmd:MD_DataIdentification>
          <gmd:citation>
            <gmd:CI_Citation>
              <!--
              <xs:element name="NomRdd" type="sa_dc:NomRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
              <xs:element name="MnRdd" type="sa_dc:MnRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <gmd:title>
                <gco:CharacterString>
                  <xsl:value-of select="NomRdd"/>
                </gco:CharacterString>
              </gmd:title>
              <xsl:for-each select="MnRdd[. != '']">
                <gmd:alternateTitle>
                  <gco:CharacterString>
                    <xsl:value-of select="."/>
                  </gco:CharacterString>
                </gmd:alternateTitle>
              </xsl:for-each>
              <!-- Date. Pour info, dans reseau261800, dans l'export XML ISO19115
                une date de création 2010-01-01 est ajouté
                alors qu'elle n'est pas dans l'export XML SINP.

              A priori correspond à AnneeMisePlaceRdd
              <xs:element name="AnneeMisePlaceRdd" type="sa_dc:AnneeMisePlaceRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
              -->
              <xsl:if test="AnneeMisePlaceRdd">
                <gmd:date>
                  <gmd:CI_Date>
                    <gmd:date>
                      <gco:Date><xsl:value-of select="AnneeMisePlaceRdd"/></gco:Date>
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

              <!-- OLD
    					<gmd:othercitationdetails>
    						<gco:CharacterString>
    							<xsl:value-of select="ModeStockageRdd/PrecisionModeStockage"/>
    						</gco:CharacterString>
    					</gmd:othercitationdetails>

    					<gmd:presentationForm>
    						<gmd:CI_PresentationFormCode>
    									<xsl:attribute name="codeList">http://www.isotc211.org/2005/resources/codeList.xml#CI_PresentationFormCode</xsl:attribute>
    									<xsl:choose>
    										<xsl:when test="ModeStockageRdd/CdModeStockage = 1"><xsl:attribute name="codeListValue">documentHardcopy</xsl:attribute></xsl:when>
    										<xsl:when test="ModeStockageRdd/CdModeStockage = 2"><xsl:attribute name="codeListValue">documentDigital</xsl:attribute></xsl:when>
    										<xsl:when test="ModeStockageRdd/CdModeStockage = 3"><xsl:attribute name="codeListValue">tableDigital</xsl:attribute></xsl:when>
    										<xsl:otherwise><xsl:attribute name="codeListValue"></xsl:attribute></xsl:otherwise>
    									</xsl:choose>

    						</gmd:CI_PresentationFormCode>
    					</gmd:presentationForm>
          -->
            </gmd:CI_Citation>
          </gmd:citation>


          <!--
          <xs:element name="DescriptionFinaliteRdd" type="sa_dc:DescriptionFinaliteRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
          -->
          <gmd:abstract>
            <gco:CharacterString>
              <xsl:value-of select="DescriptionFinaliteRdd"/>
            </gco:CharacterString>
          </gmd:abstract>


          <!-- TODO: Objectifs scientifiques
          <gmd:purpose>
            <gco:CharacterString/>
          </gmd:purpose> -->


          <!--
              <xs:element name="EtatActivite" minOccurs="0" maxOccurs="1" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdEtatActivite" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbEtatActivite" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
          -->
          <xsl:for-each select="EtatActivite/CdEtatActivite">
            <gmd:status>
              <gmd:MD_ProgressCode codeListValue="{if (. = '2') then 'completed' else 'onGoing'}"
                                   codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ProgressCode"/>
            </gmd:status>
          </xsl:for-each>


          <!--
          <xs:element name="IntervenantRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="Intervenant" minOccurs="1" maxOccurs="1" nillable="false">
                  <xs:complexType mixed="false">
                    <xs:sequence minOccurs="1" maxOccurs="1">
                      <xs:element name="CdIntervenant" type="sa_int:CdIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
                      <xs:element name="IdEchangeInt" type="sa_bp:IdEchangeInt" minOccurs="1" maxOccurs="1" nillable="false"/>
                    </xs:sequence>
                    <xs:attribute name="Role" type="xs:string" use="optional"/>
                  </xs:complexType>
                </xs:element>

                *** Non utilisé TODO XSD ? ***
                <xs:element name="DateDebutIntervenant" type="sa_dc:DateDebutIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="DateFinIntervenant" type="sa_dc:DateFinIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="PrecisionServiceIntervenant" type="sa_dc:PrecisionServiceIntervenant" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="Contacts" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:complexType mixed="false">
                    <xs:sequence minOccurs="1" maxOccurs="1">
                      <xs:element name="CdContact" type="sa_int:CdContact" minOccurs="1" maxOccurs="1" nillable="false"/>
                      <xs:element name="NomContact" type="sa_int:NomContact" minOccurs="0" maxOccurs="1" nillable="false"/>
                      <xs:element name="FonctionContact" type="sa_int:FonctionContact" minOccurs="0" maxOccurs="1" nillable="false"/>
                      <xs:element name="TelephoneContact" type="sa_int:TelephoneContact" minOccurs="0" maxOccurs="1" nillable="false"/>
                      <xs:element name="FaxContact" type="sa_int:FaxContact" minOccurs="0" maxOccurs="1" nillable="false"/>
                      <xs:element name="MailContact" type="sinp:Mail" minOccurs="0" maxOccurs="1" nillable="false"/>
                    </xs:sequence>
                  </xs:complexType>
                </xs:element>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
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

          <!-- TODO: OLD
						<xsl:for-each select="SupportRdd">
						<gmd:resourceMaintenance>
							<gmd:MD_MaintenanceInformation>
								<gmd:maintenanceAndUpdateFrequency>
									<gmd:MD_MaintenanceFrequencyCode>
										<xsl:attribute name="codeList">MD_MaintenanceFrequencyCode</xsl:attribute>
										<xsl:attribute name="codeListValue">irregular</xsl:attribute>
									</gmd:MD_MaintenanceFrequencyCode>
								</gmd:maintenanceAndUpdateFrequency>
								<gmd:maintenanceNote>
									<gco:CharacterString>
										<xsl:value-of select="FrequenceActualisation"/>
									</gco:CharacterString>
								</gmd:maintenanceNote>
							</gmd:MD_MaintenanceInformation>
						</gmd:resourceMaintenance>
						</xsl:for-each>

          -->


          <gmd:resourceMaintenance>
            <gmd:MD_MaintenanceInformation>
              <gmd:maintenanceAndUpdateFrequency>
                <gmd:MD_MaintenanceFrequencyCode codeListValue="asNeeded"
                  codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                />
              </gmd:maintenanceAndUpdateFrequency>
              <!--
              <xs:element name="DureeRdd" minOccurs="0" maxOccurs="1" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdDuree" type="sa_dc:CdDuree" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbDuree" type="sa_dc:LbDuree" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              -->
              <xsl:for-each select="DureeRdd/LbDuree">
               <gmd:maintenanceNote>
                 <gco:CharacterString>
                   <xsl:value-of select="."/>
                 </gco:CharacterString>
               </gmd:maintenanceNote>
              </xsl:for-each>
            </gmd:MD_MaintenanceInformation>
          </gmd:resourceMaintenance>

          <xsl:if test="DataKwInspire[. != '']">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="DataKwInspire[. != '']">
                 <gmd:keyword>
                   <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                 </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                    codeListValue="theme"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>GEMET - INSPIRE themes, version 1.0</gco:CharacterString>
                    </gmd:title>
                    <gmd:date>
                      <gmd:CI_Date>
                        <gmd:date>
                          <gco:Date>2008-06-01</gco:Date>
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
                            xlink:href="http://localhost:8080/geonetwork/srv/fre/thesaurus.download?ref=external.theme.inspire-theme">geonetwork.thesaurus.external.theme.inspire-theme</gmx:Anchor>
                        </gmd:code>
                      </gmd:MD_Identifier>
                    </gmd:identifier>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>

          <xsl:if test="terre_ou_mer">
           <gmd:descriptiveKeywords>
             <gmd:MD_Keywords>
               <gmd:keyword>
                 <gco:CharacterString>
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
                    <gco:CharacterString>Type de dispositif</gco:CharacterString>
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
              <!--
               <xs:element name="RegionRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdRegion" type="sa_com:CdRegion" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbRegion" type="sa_com:LbRegion" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="DepartementRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdDepartement" type="sa_com:CdDepartement" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbDepartement" type="sa_com:LbDepartement" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              -->
              <xsl:for-each select="RegionRdd|DepartementRdd">
                <gmd:keyword>
                  <gco:CharacterString>
                    <xsl:value-of select="LbRegion|LbDepartement"/>
                  </gco:CharacterString>
                </gmd:keyword>
              </xsl:for-each>
              <gmd:type>
                <gmd:MD_KeywordTypeCode codeList="" codeListValue="place"/>
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

          <!-- TODO
            Type de données observées remplacer par Cible taxonomique
            TAXREF
            - Migration mapping avec ancien tableau qui était un sous ensemble
            SupportRdd/Support/LbSupport
            -->

          <!-- TODO
          Groupe taxonomique, espèces/ habitats suivi(e)s
          SupportRdd/DescriptifTaxon
          -->

          <xsl:if test="count(descriptiveKeywords/MD_Keywords/keyword[. != '']) > 0 or
            count(keyword[. != '']) > 0">
            <gmd:descriptiveKeywords>
              <!-- OLD

							<xsl:attribute name="xlink:href"><xsl:value-of select="MD_Keywords/codeMotCle"/></xsl:attribute>
							<xsl:attribute name="xlink:role">pointOfContact</xsl:attribute>
              -->
              <gmd:MD_Keywords>
                <xsl:for-each select="descriptiveKeywords/MD_Keywords/keyword[. != '']|keyword[. != '']">
                  <gmd:keyword>
                    <gco:CharacterString>
                      <xsl:value-of select="."/>
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

          <!--
          <xs:element name="RefMilieux" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdRefMetier" type="xs:string" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbRefMetier" type="xs:string" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
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

          <!--
          <xs:element name="RefTaxons" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdRefMetier" type="xs:string" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbRefMetier" type="xs:string" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
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

          <!--
          <xs:element name="RefGeographiques" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdRefMetier" type="xs:string" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbRefMetier" type="xs:string" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
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

          <!-- Jeu de données uniquement
          <xs:element name="ModeStockageRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdModeStockage" type="sa_dc:CdModeStockage" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbModeStockage" type="sa_dc:LbModeStockage" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
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
            Acces            </gmd:dateType>
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


          <!--
          <xs:element name="TypoMilieuRss" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdTypoMilieu" type="sa_dc:CdTypoMilieu" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbTypoMilieu" type="sa_dc:LbTypoMilieu" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:if test="TypoMilieuRss/LbTypoMilieu">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="TypoMilieuRss/LbTypoMilieu">
                  <gmd:keyword>
                    <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeList="" codeListValue="theme"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>Type d'espace concerné</gco:CharacterString>
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
                                      xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-type-espace">geonetwork.thesaurus.external.theme.sinp-type-espace</gmx:Anchor>
                        </gmd:code>
                      </gmd:MD_Identifier>
                    </gmd:identifier>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>

          <!--
          <xs:element name="EmpriseAdminRdd" minOccurs="0" maxOccurs="1" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdEmpriseAdmin" type="sa_dc:CdEmpriseAdmin" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbEmpriseAdmin" type="sa_dc:LbEmpriseAdmin" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:if test="EmpriseAdminRdd">
            <gmd:descriptiveKeywords>
              <gmd:MD_Keywords>
                <xsl:for-each select="EmpriseAdminRdd/LbEmpriseAdmin">
                  <gmd:keyword>
                    <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                  </gmd:keyword>
                </xsl:for-each>
                <gmd:type>
                  <gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/codeList.xml#MD_KeywordTypeCode"
                                          codeListValue="theme"/>
                </gmd:type>
                <gmd:thesaurusName>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>Niveau territorial</gco:CharacterString>
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
                                      xlink:href="http://localhost:8080/geonetwork/srv/eng/thesaurus.download?ref=external.theme.sinp-niveau-territorial">geonetwork.thesaurus.external.theme.sinp-niveau-territorial</gmx:Anchor>
                        </gmd:code>
                      </gmd:MD_Identifier>
                    </gmd:identifier>
                  </gmd:CI_Citation>
                </gmd:thesaurusName>
              </gmd:MD_Keywords>
            </gmd:descriptiveKeywords>
          </xsl:if>

          <!--

						<gmd:descriptiveKeywords>
							<gmd:MD_Keywords>
								<xsl:for-each select="DispositifCollecte/SupportRdd/Support">
								<gmd:keyword>
									<gco:CharacterString>
										<xsl:value-of select="LbSupport"/>
									</gco:CharacterString>
								</gmd:keyword>
								</xsl:for-each>
								<gmd:type>
									<gmd:MD_KeywordTypeCode>
										<xsl:attribute name="codeList">MD_KeywordTypeCode</xsl:attribute>
										<xsl:attribute name="codeListValue">theme</xsl:attribute>
									</gmd:MD_KeywordTypeCode>
								</gmd:type>
							</gmd:MD_Keywords>
						</gmd:descriptiveKeywords>
						<gmd:descriptiveKeywords>
							<gmd:MD_Keywords>
								<gmd:keyword>
									<gco:CharacterString>
										<xsl:value-of select="DispositifCollecte/keyword"/>
									</gco:CharacterString>
								</gmd:keyword>
								<gmd:type>
									<gmd:MD_KeywordTypeCode>
										<xsl:attribute name="codeList">MD_KeywordTypeCode</xsl:attribute>
										<xsl:attribute name="codeListValue">theme</xsl:attribute>
									</gmd:MD_KeywordTypeCode>
								</gmd:type>
							</gmd:MD_Keywords>
						</gmd:descriptiveKeywords>
          -->


          <!--
          <xs:element name="ConditionsUtilisation" type="sinp:ConditionsUtilisation" minOccurs="0" maxOccurs="1" nillable="false"/>
          -->
          <xsl:for-each select="ConditionsUtilisation">
            <gmd:resourceConstraints>
              <gmd:MD_LegalConstraints>
                <gmd:otherConstraints>
                  <gco:CharacterString>
                    <xsl:value-of select="."/>
                  </gco:CharacterString>
                </gmd:otherConstraints>

                <!--
                <xs:element name="AccesDonneesRdd" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:complexType mixed="false">
                    <xs:sequence minOccurs="1" maxOccurs="1">
                      <xs:element name="CdAcces" type="sa_dc:CdAcces" minOccurs="1" maxOccurs="1" nillable="false"/>
                      <xs:element name="LbAcces" type="sa_dc:LbAcces" minOccurs="0" maxOccurs="1" nillable="false"/>
                    </xs:sequence>
                  </xs:complexType>
                </xs:element>
                -->
                <xsl:for-each select="../AccesDonneesRdd/CdAcces">
                  <gmd:classification>
                    <gmd:MD_ClassificationCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_ClassificationCode"
                                               codeListValue="{if (. = '1') then 'unclassified'
                                                               else if (. = '2') then 'restricted'
                                                               else if (. = '3') then 'confidential' else ''}"/>
                  </gmd:classification>
                </xsl:for-each>
              </gmd:MD_LegalConstraints>
            </gmd:resourceConstraints>
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
              <xsl:for-each select="AccesDonneesRdd/LbAcces">
                <gmd:otherConstraints>
                  <gco:CharacterString>
                    <xsl:value-of select="."/>
                  </gco:CharacterString>
                </gmd:otherConstraints>
              </xsl:for-each>
            </gmd:MD_LegalConstraints>
          </gmd:resourceConstraints>


          <!--
          <xs:element name="LanguesDonnees" minOccurs="0" maxOccurs="1" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdLangue" type="xs:string" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbLangue" type="xs:string" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:for-each select="LanguesDonnees">
            <gmd:language>
              <gmd:LanguageCode codeList="http://www.loc.gov/standards/iso639-2/"
                codeListValue="{if (CdLangue = 'fra') then 'fre' else CdLangue}"/>
            </gmd:language>
          </xsl:for-each>


          <gmd:characterSet>
            <gmd:MD_CharacterSetCode codeListValue="utf8" codeList="MD_CharacterSetCode" />
          </gmd:characterSet>



          <!--
          <xs:element name="Thematiques19115" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="CdThematique19115" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbThematique19115" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:for-each select="Thematique19115">
            <xsl:variable name="current" select="LbThematique19115"/>
            <gmd:topicCategory>
              <gmd:MD_TopicCategoryCode>
                <xsl:value-of select="$topicCategoryMapping/value[@key = $current]/text()"/>
              </gmd:MD_TopicCategoryCode>
            </gmd:topicCategory>
          </xsl:for-each>

          <!-- OLD
          <xsl:call-template name="extent">
						<xsl:with-param name="nd" select="DispositifCollecte/ExtentRdd"/>
						<xsl:with-param name="precisionTerritoire" select="DispositifCollecte/precisionTerritoire"/>
					</xsl:call-template>
          -->

          <xsl:for-each select="ExtentRdd">
            <gmd:extent>
              <gmd:EX_Extent>
                <xsl:for-each select="../precisionTerritoire[. != '']">
                 <gmd:description>
                   <gco:CharacterString><xsl:value-of select="../precisionTerritoire"/></gco:CharacterString>
                 </gmd:description>
                </xsl:for-each>
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
                <gco:CharacterString>Emprise réelle et effective du territoire couvert</gco:CharacterString>
              </gmd:description>
              <gmd:temporalElement>
                <gmd:EX_TemporalExtent>
                  <gmd:extent>
                    <gml:TimePeriod gml:id="{generate-id()}">
                      <gml:beginPosition/>
                      <gml:endPosition/>
                    </gml:TimePeriod>
                  </gmd:extent>
                </gmd:EX_TemporalExtent>
              </gmd:temporalElement>
            </gmd:EX_Extent>
          </gmd:extent>

          <!--
          <xs:element name="CommentairesRdd" type="sa_dc:CommentairesRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
          -->
          <xsl:for-each select="CommentairesRdd">
           <gmd:supplementalInformation>
             <gco:CharacterString>
               <xsl:value-of select="."/>
             </gco:CharacterString>
           </gmd:supplementalInformation>
          </xsl:for-each>

          <!--

						<xsl:for-each select="DispositifCollecte/Publications">
						<fra:relatedCitation>
							<gmd:CI_Citation>
								<gmd:title>
									<gco:CharacterString>
								<xsl:value-of select="TitreDoc"/>
									</gco:CharacterString>
								</gmd:title>
								<gmd:date>
									<gmd:CI_Date>
										<gmd:date>
											<gco:Date>
								<xsl:value-of select="concat(AnneeDoc, '-01-01')"/>
											</gco:Date>
										</gmd:date>
										<gmd:dateType>
											<gmd:CI_DateTypeCode>
												<xsl:attribute name="codeList">CI_DateTypeCode</xsl:attribute>
												<xsl:attribute name="codeListValue">PublicationCollectiveTitle</xsl:attribute>
											</gmd:CI_DateTypeCode>
										</gmd:dateType>
									</gmd:CI_Date>
								</gmd:date>
								<gmd:otherCitationDetails>
									<gco:CharacterString>
								<xsl:value-of select="FrequenceDoc"/>
									</gco:CharacterString>
								</gmd:otherCitationDetails>
								<gmd:citedResponsibleParty>
									<gmd:CI_ResponsibleParty>
										<gmd:individualName>
											<gco:CharacterString>
								<xsl:value-of select="AuteurDoc"/>
											</gco:CharacterString>
										</gmd:individualName>
										<gmd:role>
											<gmd:CI_roleCode>
												<xsl:attribute name="codeList">CI_roleCode</xsl:attribute>
												<xsl:attribute name="codeListValue">author</xsl:attribute>
											</gmd:CI_roleCode>
										</gmd:role>
									</gmd:CI_ResponsibleParty>
								</gmd:citedResponsibleParty>
								<gmd:series>
									<gmd:CI_Series>
										<gmd:name>
											<gco:CharacterString>
								<xsl:value-of select="VolumeDoc"/>
											</gco:CharacterString>
										</gmd:name>
										<gmd:page>
											<gco:CharacterString>
								<xsl:value-of select="PageDoc"/>
											</gco:CharacterString>
										</gmd:page>
									</gmd:CI_Series>
								</gmd:series>
							</gmd:CI_Citation>
						</fra:relatedCitation>
						</xsl:for-each>
          -->


          <!--
          <xs:element name="SupportRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="Support" minOccurs="1" maxOccurs="1" nillable="false">
                  <xs:complexType mixed="false">
                    <xs:sequence minOccurs="1" maxOccurs="1">
                      <xs:element name="CdSupport" type="sa_par:CdSupport" minOccurs="1" maxOccurs="1" nillable="false"/>
                    </xs:sequence>
                                          </xs:complexType>
                </xs:element>
                <xs:element name="FrequenceAnalyse" type="sa_dc:FrequenceAnalyse" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="DescriptifParametres" type="sa_dc:DescriptifParametres" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="GroupeParametreSupport" minOccurs="0" maxOccurs="unbounded" nillable="false">
                  <xs:complexType mixed="false">
                    <xs:sequence minOccurs="1" maxOccurs="1">
                      <xs:element name="CdGroupeParametre" type="sa_dc:CdGroupeParametre" minOccurs="1" maxOccurs="1" nillable="false"/>
                      <xs:element name="LbGroupeParametre" type="sa_dc:LbGroupeParametre" minOccurs="0" maxOccurs="1" nillable="false"/>
                    </xs:sequence>
                                          </xs:complexType>
                </xs:element>
                <xs:element name="ResolutionParametres" type="sinp:ResolutionParametres" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="FrequenceActualisation" type="sinp:FrequenceActualisation" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>

          eg.

          <SupportRdd>
            <Support>
              <CdSupport schemeAgencyID="sandre">INSE</CdSupport>
              <LbSupport>Classe des Insecta</LbSupport>
            </Support>
            <FrequenceAnalyse></FrequenceAnalyse>
            <DescriptifParametres>richesse sp&#233;cifique, abondance, indices de biodiversit&#233;
      temp&#233;rature thoracique (sphingid&#233;s), type d'exposition de la mine sur la feuille (Gracillariidae) + temp&#233;rature de la feuille</DescriptifParametres>
            <ResolutionParametres></ResolutionParametres>
            <FrequenceActualisation></FrequenceActualisation>
            <DescriptifTaxon>tous + sphingid&#233;s et mineuses Gracillariidae pour l'&#233;cologie thermique</DescriptifTaxon>
          </SupportRdd>
          -->
          <xsl:for-each select="SupportRdd">
            <sinp:observationDetails>
              <sinp:ObservationDetails>
                <sinp:descriptiveKeywords>
                  <gmd:MD_Keywords>
                    <xsl:for-each select="Support">
                      <gmd:keyword>
                        <gco:CharacterString><xsl:value-of select="LbSupport"/></gco:CharacterString>
                      </gmd:keyword>
                    </xsl:for-each>
                    <gmd:type>
                      <gmd:MD_KeywordTypeCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_KeywordTypeCode"
                                              codeListValue="theme"/>
                    </gmd:type>
                  </gmd:MD_Keywords>
                </sinp:descriptiveKeywords>

                <xsl:for-each select="DescriptifTaxon">
                  <sinp:ecologicalTarget>
                    <gco:CharacterString>
                      <xsl:value-of select="."/>
                    </gco:CharacterString>
                  </sinp:ecologicalTarget>
                </xsl:for-each>

                <xsl:for-each select="DescriptifParametres">
                  <sinp:parameter>
                    <gco:CharacterString>
                      <xsl:value-of select="."/>
                    </gco:CharacterString>
                  </sinp:parameter>
                </xsl:for-each>

                <xsl:for-each select="ResolutionParametres">
                  <sinp:resolution>
                    <gco:CharacterString>
                      <xsl:value-of select="."/>
                    </gco:CharacterString>
                  </sinp:resolution>
                </xsl:for-each>

                <xsl:for-each select="FrequenceActualisation">
                  <sinp:updateFrequency>
                    <gco:CharacterString>
                      <xsl:value-of select="."/>
                    </gco:CharacterString>
                  </sinp:updateFrequency>
                </xsl:for-each>
              </sinp:ObservationDetails>
            </sinp:observationDetails>
          </xsl:for-each>

        </gmd:MD_DataIdentification>
      </gmd:identificationInfo>


      <!--
        <xs:element name="ModeDiffusionRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
          <xs:complexType mixed="false">
            <xs:sequence minOccurs="1" maxOccurs="1">
              <xs:element name="ModeDiffusion" minOccurs="1" maxOccurs="1" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdModeTransmission" type="sa_dc:CdModeTransmission" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbModeTransmission" type="sa_dc:LbModeTransmission" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="AdresseInternetDiffusion" type="sa_dc:AdresseInternetDiffusion" minOccurs="0" maxOccurs="1" nillable="false"/>
              <xs:element name="CommModeDiffusionRdd" type="sa_dc:CommModeDiffusionRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      -->
      <xsl:if test="Tarification or ModeDiffusionRdd or Publications">
        <gmd:distributionInfo>
          <gmd:MD_Distribution>
            <xsl:if test="Tarification">
              <gmd:distributor>
                <gmd:MD_Distributor>
                  <gmd:distributorContact>
                    <xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
                  </gmd:distributorContact>
                  <xsl:for-each select="Tarification/LbTarification[. != '']">
                    <gmd:distributionOrderProcess>
                      <gmd:MD_StandardOrderProcess>
                        <gmd:fees>
                          <gco:CharacterString>
                            <xsl:value-of select="."/>
                          </gco:CharacterString>
                        </gmd:fees>
                      </gmd:MD_StandardOrderProcess>
                    </gmd:distributionOrderProcess>
                  </xsl:for-each>
                </gmd:MD_Distributor>
              </gmd:distributor>
            </xsl:if>


            <xsl:for-each select="ModeDiffusionRdd">
              <gmd:transferOptions>
                <gmd:MD_DigitalTransferOptions>
                  <gmd:onLine>
                    <gmd:CI_OnlineResource>
                      <xsl:for-each select="AdresseInternetDiffusion[. != '']">
                       <gmd:linkage>
                         <gmd:URL>
                           <xsl:value-of select="."/>
                         </gmd:URL>
                       </gmd:linkage>
                      </xsl:for-each>
                      <xsl:for-each select="ModeDiffusion/LbModeTransmission[. != '']">
                        <gmd:name>
                          <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                        </gmd:name>
                      </xsl:for-each>
                      <gmd:protocol>
                        <gco:CharacterString>WWW-LINK</gco:CharacterString>
                      </gmd:protocol>
                      <gmd:function>
                        <gmd:CI_OnLineFunctionCode>
                          <xsl:attribute name="codeList">CI_OnLineFunctionCode</xsl:attribute>
                          <xsl:attribute name="codeListValue">information</xsl:attribute>
                        </gmd:CI_OnLineFunctionCode>
                      </gmd:function>
                    </gmd:CI_OnlineResource>
                  </gmd:onLine>
                </gmd:MD_DigitalTransferOptions>
              </gmd:transferOptions>
            </xsl:for-each>



            <!--
            <xs:element name="Publications" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                <xs:element name="IdDoc" type="xs:long" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="AuteurDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="100" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
                <xs:element name="TitreDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="100" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
                <xs:element name="AnneeDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="4" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
                <xs:element name="TitreVolDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="100" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
                <xs:element name="VolumeDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="10" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
                <xs:element name="PageDoc" minOccurs="0" maxOccurs="1" nillable="false">
                  <xs:simpleType>
                    <xs:restriction base="xs:string">
                      <xs:maxLength value="20" fixed="false"/>
                    </xs:restriction>
                  </xs:simpleType>
                </xs:element>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:if test="Publications">
            <gmd:transferOptions>
              <gmd:MD_DigitalTransferOptions>
                <xsl:for-each select="Publications">
                  <gmd:onLine>
                    <gmd:CI_OnlineResource>
                      <gmd:linkage gco:nilReason="missing">
                        <gmd:URL/>
                      </gmd:linkage>
                      <gmd:name>
                        <gco:CharacterString><xsl:value-of select="TitreDoc"/></gco:CharacterString>
                      </gmd:name>
                      <gmd:description>
                        <gco:CharacterString>
                          <xsl:for-each select="TitreVolDoc[. != '']|
                                                VolumeDoc[. != '']|
                                                AnneeDoc[. != '']|
                                                PageDoc[. != '']|
                                                AuteurDoc[. != '']">
                            <xsl:variable name="name"
                                          select="if (name() = 'TitreVolDoc') then 'Titre'
                                                  else if (name() = 'VolumeDoc') then 'Volume'
                                                  else if (name() = 'AnneeDoc') then 'Année'
                                                  else if (name() = 'PageDoc') then 'Pages'
                                                  else if (name() = 'AuteurDoc') then 'Auteur'
                                                  else name(.)"/>
                            <xsl:value-of select="concat('* ', $name, ' : ', .)"/><xsl:text>
                          </xsl:text>
                          </xsl:for-each>
                        </gco:CharacterString>
                      </gmd:description>
                      <gmd:protocol>
                        <gco:CharacterString>OFFLINE</gco:CharacterString>
                      </gmd:protocol>
                      <gmd:function>
                        <gmd:CI_OnLineFunctionCode>
                          <xsl:attribute name="codeList">CI_OnLineFunctionCode</xsl:attribute>
                          <xsl:attribute name="codeListValue">information</xsl:attribute>
                        </gmd:CI_OnLineFunctionCode>
                      </gmd:function>
                    </gmd:CI_OnlineResource>
                  </gmd:onLine>
                </xsl:for-each>
              </gmd:MD_DigitalTransferOptions>
            </gmd:transferOptions>
          </xsl:if>
          </gmd:MD_Distribution>
        </gmd:distributionInfo>
      </xsl:if>


      <!--
       <xs:element name="BddRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
          <xs:complexType mixed="false">
            <xs:sequence minOccurs="1" maxOccurs="1">
              <xs:element name="Bdd" minOccurs="1" maxOccurs="1" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdBdd" type="sa_dc:CdBdd" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="MOuvrageBdd" minOccurs="1" maxOccurs="1" nillable="false">
                      <xs:complexType mixed="false">
                        <xs:sequence minOccurs="1" maxOccurs="1">
                          <xs:element name="CdIntervenant" type="sa_int:CdIntervenant" minOccurs="1" maxOccurs="1"
                                      nillable="false"/>
                          <xs:element name="IdEchangeInt" type="sa_bp:IdEchangeInt" minOccurs="1" maxOccurs="1"
                                      nillable="false"/>
                        </xs:sequence>
                      </xs:complexType>
                    </xs:element>
                    <xs:element name="IdEchangeBdd" type="sa_bp:IdEchangeBdd" minOccurs="1" maxOccurs="1"
                                nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              <xs:element name="FrequenceBancarisationBddRdd" minOccurs="0" maxOccurs="1" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="CdFrequence" type="sa_dc:CdFrequence" minOccurs="1" maxOccurs="1"
                                nillable="false"/>
                    <xs:element name="LbFrequence" type="sa_dc:LbFrequence" minOccurs="0" maxOccurs="1"
                                nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      -->


      <!-- OLD
				<xsl:for-each select="DispositifCollecte/BddRdd/Bdd">
					<xsl:variable name="idBdd" select="./IdEchangeBdd"/>
					<xsl:call-template name="base">
						<xsl:with-param name="nd" select="/SI_DC/Bdd[(IdEchangeBdd = $idBdd)]"/>
					</xsl:call-template>
				</xsl:for-each>


		<xsl:template name="base">
			<xsl:param name="nd"/>
			<gmd:distributionInfo>
				<gmd:MD_Distribution>
					<gmd:distributor>
						<gmd:MD_Distributor>
							<gmd:distributorContact>
								<xsl:variable name="idInt" select="$nd/MOuvrageBdd/IdEchangeInt"/>
								<xsl:call-template name="acteur">
									<xsl:with-param name="nd" select="/SI_DC/Intervenant[IdEchangeInt = $idInt]"/>
									<xsl:with-param name="role">distributor</xsl:with-param>
								</xsl:call-template>
							</gmd:distributorContact>

							<gmd:distributorTransferOptions>
								<gmd:MD_DigitalTransferOptions>
									<gmd:unitsOfDistribution>
										<gco:CharacterString>
											<xsl:value-of select="$nd/LbBdd"/>
										</gco:CharacterString>
									</gmd:unitsOfDistribution>

									<gmd:onLine>
										<gmd:CI_OnlineResource>
											<gmd:linkage>
												<gmd:URL>
											<xsl:value-of select="$nd/AdresseURLBdd"/>
												</gmd:URL>
											</gmd:linkage>
										</gmd:CI_OnlineResource>
									</gmd:onLine>

								</gmd:MD_DigitalTransferOptions>
							</gmd:distributorTransferOptions>
						</gmd:MD_Distributor>
					</gmd:distributor>
				</gmd:MD_Distribution>
			</gmd:distributionInfo>
		</xsl:template>
      -->

      <xsl:for-each select="BddRdd/Bdd">
        <gmd:distributionInfo>
          <gmd:MD_Distribution>
            <gmd:distributor>
              <gmd:MD_Distributor>
                <xsl:for-each select="MOuvrageBdd">
                  <xsl:variable name="code" select="CdIntervenant"/>
                  <xsl:variable name="role" select="'MOE'"/>
                  <gmd:distributorContact>
                    <xsl:apply-templates mode="sinp-contact"
                                         select="/SI_DC/Intervenant[CdIntervenant = $code]">
                      <xsl:with-param name="role" select="$roleMapping/value[@key = $role]/text()"/>
                    </xsl:apply-templates>
                  </gmd:distributorContact>
                </xsl:for-each>

                <xsl:variable name="cdBdd" select="CdBdd"/>
                <xsl:for-each select="/SI_DC/Bdd[CdBdd = $cdBdd]">
                  <!-- TODO discuss -->
                  <xsl:if test="AdresseURLBdd">
                    <gmd:distributorTransferOptions>
                      <gmd:MD_DigitalTransferOptions>
                        <gmd:onLine>
                          <gmd:CI_OnlineResource>
                            <gmd:linkage>
                              <gmd:URL>
                                <xsl:value-of select="AdresseURLBdd"/>
                              </gmd:URL>
                            </gmd:linkage>
                            <gmd:name>
                              <gco:CharacterString>
                                <xsl:value-of select="LbUsuelBdd"/>
                              </gco:CharacterString>
                            </gmd:name>
                            <gmd:description>
                              <gco:CharacterString>
                                <xsl:value-of select="CommBdd"/>
                              </gco:CharacterString>
                            </gmd:description>
                            <gmd:protocol>
                              <gco:CharacterString>
                                WWW:LINK
                              </gco:CharacterString>
                            </gmd:protocol>
                          </gmd:CI_OnlineResource>
                        </gmd:onLine>

                      </gmd:MD_DigitalTransferOptions>
                    </gmd:distributorTransferOptions>
                  </xsl:if>

                  <gmd:distributorTransferOptions>
                    <sinp:MD_DigitalTransferOptions gco:isoType="gmd:MD_DigitalTransferOptions">
                      <sinp:database>
                        <sinp:Database uuid="{CdBdd}">
                          <sinp:name>
                            <gco:CharacterString>
                              <xsl:value-of select="LbBdd"/>
                            </gco:CharacterString>
                          </sinp:name>
                          <xsl:for-each select="AdresseURLBdd">
                          <sinp:url>
                            <gco:CharacterString>
                              <xsl:value-of select="."/>
                            </gco:CharacterString>
                          </sinp:url>
                          </xsl:for-each>
                          <sinp:startYear>
                            <gco:Date>
                              <xsl:value-of select="AnneeBdd"/>
                            </gco:Date>
                          </sinp:startYear>
                          <xsl:for-each select="EvenementsBdd">
                            <sinp:history>
                              <gmd:LI_ProcessStep>
                                <gmd:description>
                                  <gco:CharacterString>
                                    <xsl:value-of select="LbEvenement"/>
                                  </gco:CharacterString>
                                </gmd:description>
                                <gmd:dateTime>
                                  <gco:Date><xsl:value-of select="DateEvenement"/></gco:Date>
                                </gmd:dateTime>
                              </gmd:LI_ProcessStep>
                            </sinp:history>
                          </xsl:for-each>

                          <xsl:for-each select="Contact">
                            <sinp:contact>
                              <sinp:CI_ResponsibleParty uuid="{CdContact}"
                                                        gco:isoType="gmd:CI_ResponsibleParty">
                                <gmd:individualName>
                                  <gco:CharacterString>
                                    <xsl:value-of select="concat(PrenomContact, ' ', NomContact)"/>
                                  </gco:CharacterString>
                                </gmd:individualName>
                                <gmd:organisationName>
                                  <gco:CharacterString>
                                    <xsl:value-of select="ServiceContact"/>
                                  </gco:CharacterString>
                                </gmd:organisationName>
                                <gmd:positionName>
                                  <gco:CharacterString>
                                    <xsl:value-of select="FonctionContact"/>
                                  </gco:CharacterString>
                                </gmd:positionName>
                                <gmd:contactInfo>
                                  <gmd:CI_Contact>
                                    <gmd:address>
                                      <gmd:CI_Address>
                                        <gmd:electronicMailAddress gco:nilReason="missing">
                                          <gco:CharacterString/>
                                        </gmd:electronicMailAddress>
                                      </gmd:CI_Address>
                                    </gmd:address>
                                  </gmd:CI_Contact>
                                </gmd:contactInfo>
                                <gmd:role>
                                  <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                                                   codeListValue=""/>
                                </gmd:role>
                              </sinp:CI_ResponsibleParty>
                            </sinp:contact>
                          </xsl:for-each>
                        </sinp:Database>
                      </sinp:database>
                    </sinp:MD_DigitalTransferOptions>
                  </gmd:distributorTransferOptions>
                </xsl:for-each>
              </gmd:MD_Distributor>
            </gmd:distributor>
          </gmd:MD_Distribution>
        </gmd:distributionInfo>
      </xsl:for-each>


      <!--
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
                    <gco:CharacterString>WWW:LINK</gco:CharacterString>
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
                    <gco:CharacterString>OGC:WMS</gco:CharacterString>
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
      </gmd:distributionInfo>-->

      <!--
      OLD

				<xsl:for-each select="DispositifCollecte/ValidationRdd/LbProcValidation">
					<xsl:call-template name="usability">
						<xsl:with-param name="code" select="."/>
						<xsl:with-param name="nameOfMeasure">Validation</xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>

				<gmd:dataQualityInfo>
					<gmd:DQ_Element>
						<gmd:measureDescription>
							<gco:CharacterString>
								<xsl:value-of select="PrecisionNbTotalRdd"/>
							</gco:CharacterString>
						</gmd:measureDescription>
					</gmd:DQ_Element>
				</gmd:dataQualityInfo>
      -->
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


          <!-- Liste des procédures de validation du dispositif
          <xs:element name="ValidationRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
            <xs:complexType mixed="false">
              <xs:sequence minOccurs="1" maxOccurs="1">
                Valeurs possibles
                  0 Inconnu
                  1 expertise humaine
                  2 test de cohérence
                  3 test scientifique

                <xs:element name="CdProcValidation" type="sa_dc:CdProcValidation" minOccurs="1" maxOccurs="1" nillable="false"/>
                <xs:element name="LbProcValidation" type="sa_dc:LbProcValidation" minOccurs="0" maxOccurs="1" nillable="false"/>
                <xs:element name="DescMethodeValidation" type="sinp:DescMethodeValidation" minOccurs="0" maxOccurs="1" nillable="false"/>
              </xs:sequence>
            </xs:complexType>
          </xs:element>
          -->
          <xsl:for-each select="ValidationRdd">
            <gmd:report>
              <gmd:DQ_DomainConsistency>
                <gmd:evaluationMethodType>
                  <gmd:DQ_EvaluationMethodTypeCode
                    codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#DQ_EvaluationMethodTypeCode"
                    codeListValue="directInternal"/>
                </gmd:evaluationMethodType>
                <xsl:for-each select="DescMethodeValidation">
                  <gmd:evaluationMethodDescription>
                    <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                  </gmd:evaluationMethodDescription>
                </xsl:for-each>
                <gmd:evaluationProcedure>
                  <gmd:CI_Citation>
                    <gmd:title>
                      <gco:CharacterString>Procédures de validation du dispositif
                        <xsl:if test="LbProcValidation">
                          / <xsl:value-of select="LbProcValidation"/>
                        </xsl:if>
                        <xsl:if test="CdProcValidation">
                          / <xsl:choose>
                            <xsl:when test="CdProcValidation = 0">Inconnu</xsl:when>
                            <xsl:when test="CdProcValidation = 1">Expertise humaine</xsl:when>
                            <xsl:when test="CdProcValidation = 2">Test de cohérence</xsl:when>
                            <xsl:when test="CdProcValidation = 3">Rest scientifique</xsl:when>
                          </xsl:choose>
                        </xsl:if>
                      </gco:CharacterString>
                    </gmd:title>
                  </gmd:CI_Citation>
                </gmd:evaluationProcedure>
              </gmd:DQ_DomainConsistency>
            </gmd:report>
          </xsl:for-each>

          <gmd:lineage>
            <gmd:LI_Lineage>
              <gmd:statement>
                <xsl:choose>
                  <xsl:when test="Genealogie[. != '']">
                    <gco:CharacterString>
                      <xsl:value-of select="Genealogie"/>
                    </gco:CharacterString>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="gco:nilReason">missing</xsl:attribute>
                    <gco:CharacterString/>
                  </xsl:otherwise>
                </xsl:choose>

              </gmd:statement>
              <!--
              <xs:element name="HistoriqueEvtsRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="DtHistoriqueEvtsRdd" type="sa_bp:DtHistoriqueEvtsRdd" minOccurs="1" maxOccurs="1" nillable="false"/>
                    <xs:element name="TypeHistoriqueEvtsRdd" type="sa_bp:TypeHistoriqueEvtsRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
                    <xs:element name="DesHistoriqueEvtsRdd" type="sa_bp:DesHistoriqueEvtsRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
                    <xs:element name="AuteurHistoriqueEvtsRdd" type="sa_bp:AuteurHistoriqueEvtsRdd" minOccurs="1" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              -->
              <xsl:for-each select="HistoriqueEvtsRdd">
                <xsl:sort select="DtHistoriqueEvtsRdd" order="descending"/>
                <gmd:processStep>
                  <gmd:LI_ProcessStep>
                    <gmd:description>
                      <gco:CharacterString>
                        <xsl:value-of select="DesHistoriqueEvtsRdd"/>
                      </gco:CharacterString>
                    </gmd:description>
                    <xsl:for-each select="TypeHistoriqueEvtsRdd">
                      <gmd:rationale>
                        <gco:CharacterString>
                          <xsl:choose>
                            <xsl:when test=". = '1'">Création</xsl:when>
                            <xsl:when test=". = '2'">Modification</xsl:when>
                            <xsl:when test=". = '3'">Changement de statut</xsl:when>
                            <xsl:when test=". = '4'">Synchronisation</xsl:when>
                          </xsl:choose>
                        </gco:CharacterString>
                      </gmd:rationale>
                    </xsl:for-each>
                    <gmd:dateTime>
                      <gco:DateTime>
                        <xsl:value-of select="DtHistoriqueEvtsRdd"/>
                      </gco:DateTime>
                    </gmd:dateTime>
                    <xsl:for-each select="AuteurHistoriqueEvtsRdd">
                      <gmd:processor>
                        <sinp:CI_ResponsibleParty gco:isoType="gmd:CI_ResponsibleParty">
                          <gmd:organisationName>
                            <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                          </gmd:organisationName>
                          <gmd:role>
                            <gmd:CI_RoleCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#CI_RoleCode"
                                             codeListValue="pointOfContact"/>
                          </gmd:role>
                        </sinp:CI_ResponsibleParty>
                      </gmd:processor>
                    </xsl:for-each>
                  </gmd:LI_ProcessStep>
                </gmd:processStep>
              </xsl:for-each>

              <!--
              <xs:element name="EvenementsRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
                <xs:complexType mixed="false">
                  <xs:sequence minOccurs="1" maxOccurs="1">
                    <xs:element name="DateEvenement" type="sa_dc:DateEvenement" minOccurs="0" maxOccurs="1" nillable="false"/>
                    <xs:element name="LbEvenement" type="sa_dc:LbEvenement" minOccurs="0" maxOccurs="1" nillable="false"/>
                  </xs:sequence>
                </xs:complexType>
              </xs:element>
              -->
              <xsl:for-each select="EvenementsRdd">
                <gmd:processStep>
                  <gmd:LI_ProcessStep>
                    <gmd:description>
                      <gco:CharacterString>
                        <xsl:value-of select="LbEvenement"/>
                      </gco:CharacterString>
                    </gmd:description>
                    <gmd:dateTime>
                      <gco:DateTime>
                        <xsl:value-of select="concat(DateEvenement, 'T12:00:00')"/>
                      </gco:DateTime>
                    </gmd:dateTime>
                  </gmd:LI_ProcessStep>
                </gmd:processStep>
              </xsl:for-each>
            </gmd:LI_Lineage>
          </gmd:lineage>
        </gmd:DQ_DataQuality>
      </gmd:dataQualityInfo>

      <!--
      <xs:element name="DemarcheQualiteRdd" minOccurs="0" maxOccurs="unbounded" nillable="false">
        <xs:complexType mixed="false">
          <xs:sequence minOccurs="1" maxOccurs="1">
            <xs:element name="DateDemarcheQualite" type="sa_dc:DateDemarcheQualite" minOccurs="0" maxOccurs="1" nillable="false"/>
            <xs:element name="ReferenceDocDemarcheQualite" type="sa_dc:ReferenceDocDemarcheQualite" minOccurs="0" maxOccurs="1" nillable="false"/>
            <xs:element name="TypeQualite" minOccurs="0" maxOccurs="1" nillable="false">
              <xs:complexType mixed="false">
                <xs:sequence minOccurs="1" maxOccurs="1">
                  <xs:element name="CdTypeQualite" type="sa_dc:CdTypeQualite" minOccurs="1" maxOccurs="1" nillable="false"/>
                  <xs:element name="LbTypeQualite" type="sa_dc:LbTypeQualite" minOccurs="0" maxOccurs="1" nillable="false"/>
                </xs:sequence>
                                      </xs:complexType>
            </xs:element>
            <xs:element name="MethodeQualite" type="sinp:MethodeQualite" minOccurs="0" maxOccurs="1" nillable="false"/>
          </xs:sequence>
        </xs:complexType>
      </xs:element>
      -->
      <xsl:for-each select="DemarcheQualiteRdd">

        <gmd:dataQualityInfo>
          <gmd:DQ_DataQuality>
            <xsl:for-each select="ValidationRdd">
              <gmd:report>
                <gmd:DQ_DomainConsistency>
                  <gmd:evaluationMethodType>
                    <gmd:DQ_EvaluationMethodTypeCode
                      codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#DQ_EvaluationMethodTypeCode"
                      codeListValue="directInternal"/>
                  </gmd:evaluationMethodType>
                  <xsl:for-each select="MethodeQualite/LbMethodeQualite">
                    <gmd:evaluationMethodDescription>
                      <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                    </gmd:evaluationMethodDescription>
                  </xsl:for-each>
                  <gmd:evaluationProcedure>
                    <gmd:CI_Citation>
                      <gmd:title>
                        <gco:CharacterString>
                          <xsl:choose>
                            <xsl:when test="TypeQualite">
                              <xsl:value-of select="TypeQualite/LbTypeQualite"/>
                            </xsl:when>
                            <xsl:otherwise>Démarche qualité</xsl:otherwise>
                          </xsl:choose>
                        </gco:CharacterString>
                      </gmd:title>

                      <xsl:for-each select="DateDemarcheQualite">
                        <gmd:dateTime>
                          <gco:DateTime>
                            <xsl:value-of select="."/>
                          </gco:DateTime>
                        </gmd:dateTime>
                      </xsl:for-each>

                      <xsl:for-each select="ReferenceDocDemarcheQualite">
                        <gmd:otherCitationDetails>
                          <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
                        </gmd:otherCitationDetails>
                      </xsl:for-each>
                    </gmd:CI_Citation>
                  </gmd:evaluationProcedure>
                </gmd:DQ_DomainConsistency>
              </gmd:report>
            </xsl:for-each>
          </gmd:DQ_DataQuality>
        </gmd:dataQualityInfo>
      </xsl:for-each>

      <!--
      <xs:element name="EtatAvancementFicheRdd" type="sa_dc:EtatAvancementFicheRdd" minOccurs="0" maxOccurs="1" nillable="false"/>
      -->
      <xsl:for-each select="EtatAvancementFicheRdd">
        <gmd:metadataMaintenance xmlns:xs="http://www.w3.org/2001/XMLSchema">
          <gmd:MD_MaintenanceInformation>
            <gmd:maintenanceAndUpdateFrequency>
              <gmd:MD_MaintenanceFrequencyCode codeList="http://standards.iso.org/ittf/PubliclyAvailableStandards/ISO_19139_Schemas/resources/codelist/ML_gmxCodelists.xml#MD_MaintenanceFrequencyCode"
                                               codeListValue="irregular"/>
            </gmd:maintenanceAndUpdateFrequency>
            <gmd:updateScopeDescription/>
            <gmd:maintenanceNote>
              <gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
            </gmd:maintenanceNote>
          </gmd:MD_MaintenanceInformation>
        </gmd:metadataMaintenance>
      </xsl:for-each>
    </gmd:MD_Metadata>
  </xsl:template>

  <xsl:template match="*" mode="sinp"/>
</xsl:stylesheet>
