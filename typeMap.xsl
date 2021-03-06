<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template name="citeprocRemap">
	<xsl:param name="cslUsage"/>
	<xsl:param name="descKey"/>
			<a href="#cslVar-{$descKey}"><xsl:value-of select="$cslUsage"/></a>
</xsl:template>

<xsl:template name="cslVarForZField">
	<xsl:param name="name"/>
	<ul class="inline-list">
		<xsl:for-each select="$name">
			<li>
				<xsl:choose>
					<xsl:when test="/map/citeprocJStoCSLmap/remap[@citeprocField=current()/@cslField]">
						<xsl:call-template name="citeprocRemap">
							<xsl:with-param name="cslUsage" select="/map/citeprocJStoCSLmap/remap[@citeprocField=current()/@cslField]/@cslUsage"/>
							<xsl:with-param name="descKey" select="/map/citeprocJStoCSLmap/remap[@citeprocField=current()/@cslField]/@descKey"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<a href="#cslVar-{@cslField}"><xsl:value-of select="@cslField"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</li>
		</xsl:for-each>
	</ul>
</xsl:template>

<xsl:template match="/">
  <html>
  <head>
    <link rel="stylesheet" type="text/css" href="typeMap.css" />
  </head>
  <body>
    <h2><a name="toc">Zotero Item Types</a></h2>
    <h4>Generated with Zotero <xsl:value-of select="map/zoteroVersion/@value"/> on <xsl:value-of select="map/date/@value"/></h4>
    <table>
      <thead>
          <tr><th>Zotero type</th><th>CSL type</th></tr>
      </thead>
      <tbody>
      <xsl:for-each select="map/zTypes/typeMap">
        <xsl:sort select="@zType"/>
        <tr>
          <td><a href="#map-{@zType}"><xsl:value-of select="@zType"/></a></td>
          <td><xsl:value-of select="@cslType"/></td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="map/cslVars/itemTypes/type">
        <xsl:sort select="@name"/>
        <xsl:if test="not(/map/zTypes/typeMap[@cslType=current()/@name])">
        <tr>
          <td></td>
          <td><xsl:value-of select="@name"/></td>
        </tr>
        </xsl:if>
      </xsl:for-each>
      </tbody>
    </table>
    <hr />
    <h3>CSL variable descriptions</h3>
    <table>
    	<thead><tr><th>CSL variable</th><th>Description</th></tr></thead>
    	<tbody>
				<xsl:for-each select="map/cslVars/vars/var">
        <xsl:sort select="@name"/>
        <tr>
	        <td><a name="cslVar-{@name}"><xsl:value-of select="@name"/></a>
	        	<xsl:if test="not(/map/cslFieldMap/map[@cslField=current()/@name] | /map/cslCreatorMap/map[@cslField=current()/@name] | /map/citeprocJStoCSLmap/remap[@descKey=current()/@name])">*</xsl:if>
	        </td>
	        <td>[<xsl:value-of select="@type"/>] <xsl:value-of select="@description"/></td>
        </tr>
    		</xsl:for-each>
    	</tbody>
    </table>
		* CSL variable has no corresponding Zotero field
    <xsl:for-each select="map/zTypes/typeMap">
    <xsl:sort select="@zType"/>
      <hr />
      (<a href="#toc">top</a>)
      <h3><a name="map-{@zType}"><xsl:value-of select="@zType"/> &#x2192; <xsl:value-of select="@cslType"/></a></h3>
      <table>
        <thead>
            <tr><th>UI Label</th><th>Zotero field</th><th>CSL field</th></tr>
        </thead>
        <tbody>
        <xsl:for-each select="field">
        <xsl:sort select="@value"/>
          <tr>
            <td>
              <xsl:value-of select="@label"/>
            </td>
            <td>
              <xsl:value-of select="@value"/>
              <xsl:if test="@baseField"> (<xsl:value-of select="@baseField"/>)</xsl:if>
            </td>
            <td>
            <xsl:call-template name="cslVarForZField">
            	<xsl:with-param name="name" select="/map/cslFieldMap/map[@zField=current()/@baseField] | /map/cslFieldMap/map[not(current()/@baseField) and @zField=current()/@value]"/>
            </xsl:call-template>
            </td>
          </tr>
          <xsl:if test="@value = 'creator'">
            <xsl:for-each select="creatorType">
            <xsl:sort select="@value"/>
              <tr>
                <td class="zSubType">
                  <xsl:value-of select="@label"/>
                </td>
                <td class="zSubType">
                  <xsl:value-of select="@value"/>
                  <xsl:if test="@baseField"> (<xsl:value-of select="@baseField"/>)</xsl:if>
                </td>
                <td class="zSubType">
                <xsl:call-template name="cslVarForZField">
                  <xsl:with-param name="name" select="/map/cslCreatorMap/map[@zField=current()/@baseField] | /map/cslCreatorMap/map[not(current()/@baseField) and @zField=current()/@value]"/>
                </xsl:call-template>
                </td>
              </tr>
            </xsl:for-each>
          </xsl:if>
        </xsl:for-each>
        </tbody>
      </table>
    </xsl:for-each>
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>