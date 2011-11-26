<?xml version="1.0" encoding="UTF-8"?>

<!-- Copyright (C) 2002 Albert Tumanov

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

-->
<!--$Header: /cvsroot/pldoc/sources/src/resources/unit.xsl,v 1.5 2004/07/06 13:04:58 altumano Exp $-->

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:java="java"
  xmlns:exslt="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  xmlns:lxslt="http://xml.apache.org/xslt"
  xmlns:redirect="http://xml.apache.org/xalan/redirect"
  extension-element-prefixes="redirect str java">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>
  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
  <xsl:param name="targetFolder"/>
  
  <!-- ********************** NAVIGATION BAR TEMPLATE ********************** -->
  <xsl:template name="NavigationBar">
    <TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">
    <TR>
    <TD COLSPAN="2" CLASS="NavBarRow1">
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
      <TR ALIGN="center" VALIGN="top">
      <TD CLASS="NavBarRow1"><A HREF="summary.html"><FONT CLASS="NavBarFont1"><B>Overview</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="deprecated-list.html"><FONT CLASS="NavBarFont1"><B>Deprecated</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="index-list.html"><FONT CLASS="NavBarFont1"><B>Index</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="generator.html"><FONT CLASS="NavBarFont1"><B>Generator</B></FONT></A> &nbsp;</TD>
      </TR>
    </TABLE>
    </TD>
    <TD ALIGN="right" VALIGN="top" rowspan="3"><EM>
      <b><xsl:value-of select="../@NAME"/></b></EM>
    </TD>
    </TR>

    <TR>
    <TD VALIGN="top" CLASS="NavBarRow3"><FONT SIZE="-2">
      SUMMARY:  <A HREF="#field_summary">FIELD</A> | <A HREF="#type_summary">TYPE</A> | <A HREF="#method_summary">METHOD</A></FONT></TD>
    <TD VALIGN="top" CLASS="NavBarRow3"><FONT SIZE="-2">
    DETAIL:  <A HREF="#field_detail">FIELD</A> | <A HREF="#type_detail">TYPE</A> | <A HREF="#method_detail">METHOD</A></FONT></TD>
    </TR>
    </TABLE>
    <HR/>
  </xsl:template>

  <!-- ***************** CUSTOM TAGS TEMPLATE ****************** -->
  <!-- Special defined custom tags are processed here ! -->
  <xsl:template name="CustomTagsTemplate">

	<DL>
		<!-- deprecated -->
        <xsl:if test="TAG[@TYPE='@deprecated' or @TYPE='@DEPRECATED' ]">
  	      <DT>Deprecated:</DT>
		  <xsl:for-each select="TAG[@TYPE='@deprecated' or @TYPE='@DEPRECATED']">
	        <DD>
	        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
	        </xsl:for-each>
	        </DD>
	      </xsl:for-each>
	      <P/>
        </xsl:if>
		
		<!-- value -->
        <xsl:if test="TAG[@TYPE='@value' or @TYPE='@VALUE' ]">
          <DT>Value:</DT>
          <xsl:for-each select="TAG[@TYPE='@value' or @TYPE='@VALUE' ]">
            <DD><CODE><xsl:value-of select="@NAME"/></CODE> -
              <xsl:for-each select="COMMENT">
              <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
              <xsl:call-template name="processInlineTag">
                <xsl:with-param name="comment" select="." />
                <xsl:with-param name="tag" select="'link'" />
              </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>
        
		<!-- usage -->
        <xsl:if test="TAG[@TYPE='@usage' or @TYPE='@USAGE']">
          <DT>Usage:</DT>
          <xsl:for-each select="TAG[@TYPE='@usage' or @TYPE='@USAGE' ]">
            <DD>
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>
        
		<!-- author -->
        <xsl:if test="TAG[@TYPE='@author' or @TYPE='@AUTHOR' ]">
          <DT>Author:</DT>
          <xsl:for-each select="TAG[@TYPE='@author' or @TYPE='@AUTHOR' ]">
            <DD>
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>
        
		<!-- version -->
        <xsl:if test="TAG[@TYPE='@version' or @TYPE='@VERSION' ]">
          <DT>Version:</DT>
          <xsl:for-each select="TAG[@TYPE='@version' or @TYPE='@VERSION' ]">
            <DD>
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>

		<!-- since -->
        <xsl:if test="TAG[@TYPE='@since' or @TYPE='@SINCE' ]">
          <DT>Since:</DT>
          <xsl:for-each select="TAG[@TYPE='@since' or @TYPE='@SINCE' ]">
            <DD>
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>
        
		<!-- see -->
        <xsl:if test="TAG[@TYPE='@see' or @TYPE='@SEE'   ]">
          <DT>See also:</DT>
          <xsl:for-each select="TAG[@TYPE='@see' or @TYPE='@SEE' ]">
            <DD>
              <xsl:for-each select="COMMENT">
            <!--
            <xsl:comment>
              CustomTagsTemplate.FoundComment=START<xsl:value-of select="." disable-output-escaping="yes"/>END
              CustomTagsTemplate.FoundCommentText=START<xsl:value-of select="text()" disable-output-escaping="yes"/>END
            </xsl:comment>
            -->
	            <A>
            	<xsl:choose>
            	  <xsl:when test="starts-with(., '&lt;') or starts-with(., 'http://') or starts-with(., 'https://')"> <!-- External Link pass out unmodified-->
            	    <xsl:attribute name="href"><xsl:value-of select="." disable-output-escaping="yes"/></xsl:attribute>
            	    <xsl:value-of select="." disable-output-escaping="yes"/>
            	  </xsl:when>
            	  <xsl:when test="starts-with(., '#')"> <!-- Internal Link -->
                	<xsl:attribute name="href"><xsl:value-of select="." disable-output-escaping="yes"/></xsl:attribute>
                	<xsl:value-of select="substring-after(., '#')" disable-output-escaping="yes"/>
            	  </xsl:when>
            	  <xsl:otherwise>
  	            	<xsl:choose>
	            	  <xsl:when test="string-length(substring-before(., '#')) &lt; 1">
	               		<xsl:attribute name="href"><xsl:value-of select="translate(., $uppercase, $lowercase)" disable-output-escaping="yes"/>.html</xsl:attribute>
	               		<xsl:value-of select="." disable-output-escaping="yes"/>
	            	  </xsl:when>
                	  <xsl:otherwise>
	               		<xsl:attribute name="href"><xsl:value-of select="translate(concat(substring-before(., '#'), '.html#', substring-after(., '#')) ,$uppercase, $lowercase) " disable-output-escaping="yes"/></xsl:attribute>
	               		<xsl:value-of select="substring-before(., '#')" disable-output-escaping="yes"/>.<xsl:value-of select="substring-after(., '#')" disable-output-escaping="yes"/>
                	  </xsl:otherwise>
  	                </xsl:choose>
            	  </xsl:otherwise>
            	</xsl:choose>
            	</A>
              </xsl:for-each>
            </DD>
          </xsl:for-each>
        </xsl:if>
        
	</DL>     
	   
  </xsl:template>

  <!-- ***************** TYPE name to OBJECT TYPE LINK TEMPLATE ****************** -->
  <!-- If possible, convert the plain-text TYPE name to a link to a matching OBJECT TYPE in the Application -->
  <xsl:template name="GenerateTypeLink">
    <xsl:param name="typeName" />
    <xsl:param name="schemaName" />
    <xsl:param name="localTypeName" />
    <xsl:variable name="fieldType" select="translate($typeName, $uppercase, $lowercase)" />
      <xsl:choose>
      <xsl:when test=" string-length($localTypeName) > 0  ">
           <xsl:comment>localTypeNameParameter</xsl:comment>
	    <A>
		<xsl:attribute name="href">#<xsl:value-of select="translate($localTypeName, $uppercase, $lowercase)" disable-output-escaping="yes"/></xsl:attribute>
		<xsl:value-of select="$typeName" disable-output-escaping="yes"/>
            </A>
      </xsl:when>
      <xsl:when test="/APPLICATION/OBJECT_TYPE[ translate(@NAME, $uppercase, $lowercase)  = $fieldType ] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="$fieldType" disable-output-escaping="yes"/>.html</xsl:attribute>
		<xsl:value-of select="$typeName" disable-output-escaping="yes"/>
            </A>
      </xsl:when>
                 <!-- Package Type owned by same schema -->
      <xsl:when test="contains ($typeName, '.') and /APPLICATION/PACKAGE[ translate(@NAME, $uppercase, $lowercase)  = translate(substring-before($typeName,'.'), $uppercase, $lowercase)  ]/TYPE[ translate(@NAME, $uppercase, $lowercase)  = translate(substring-after($typeName,'.'), $uppercase, $lowercase)  ] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="concat(translate(substring-before($typeName,'.'),$uppercase,$lowercase) , '.html#', translate(substring-after($typeName,'.'),$uppercase,$lowercase) )" disable-output-escaping="yes"/></xsl:attribute>
		<xsl:value-of select="$typeName" disable-output-escaping="yes"/>
            </A>
      </xsl:when>
                 <!-- Object Type owned by other schema -->
		 <xsl:when test="contains ($typeName, '.') and /APPLICATION/OBJECT_TYPE[ translate(@SCHEMA, $uppercase, $lowercase)  = translate(substring-before($typeName,'.'), $uppercase, $lowercase)  and translate(@NAME, $uppercase, $lowercase)  = translate(substring-after($typeName,'.'), $uppercase, $lowercase)  ] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="translate(substring-after($typeName,'.'), $uppercase, $lowercase)" disable-output-escaping="yes"/>.html</xsl:attribute>
		<xsl:value-of select="$typeName" disable-output-escaping="yes"/>
            </A>
     </xsl:when>
                 <!-- Package Type owned by other schema -->
     <xsl:when test="contains ($typeName, '.') and /APPLICATION/PACKAGE[ translate(@SCHEMA, $uppercase, $lowercase)  = translate(substring-before($typeName,'.'), $uppercase, $lowercase)  and translate(@NAME, $uppercase, $lowercase)  = translate(substring-before(substring-after($typeName, '.'),'.'), $uppercase, $lowercase)  ]/TYPE[ translate(@NAME, $uppercase, $lowercase)  = translate(substring-after(substring-after($typeName,'.'),'.'), $uppercase, $lowercase)  ] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="concat(translate(substring-before(substring-after($typeName,'.'),'.'),$uppercase,$lowercase), '.html#', translate(substring-after(substring-after($typeName,'.'),'.'),$uppercase,$lowercase))" disable-output-escaping="yes"/></xsl:attribute>
		<xsl:value-of select="$typeName" disable-output-escaping="yes"/>
            </A>
     </xsl:when>
     <xsl:otherwise>
		  <xsl:value-of select="$typeName" />
     </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- -->

  <!-- ***************** Link tag to TYPE LINK TEMPLATE ****************** -->
  <!-- If possible, convert the plain-text LINK to a link to a matching PACKAGE or OBJECT TYPE link in the Application -->
  <xsl:template name="LinkTagToLink">
    <xsl:param name="label" />
    <xsl:param name="link" />
    <A>
      <xsl:choose>
        <xsl:when test="starts-with($link, '&lt;') or starts-with($link, 'http://') or starts-with($link, 'https://')"> <!-- External Link pass out unmodified-->
          <xsl:attribute name="href"><xsl:value-of select="$link" disable-output-escaping="yes"/></xsl:attribute>
          <xsl:value-of select="$label" disable-output-escaping="yes"/>
        </xsl:when>
        <xsl:when test="starts-with($link, '#')"> <!-- Internal Link -->
          <xsl:attribute name="href"><xsl:value-of select="$link" disable-output-escaping="yes"/></xsl:attribute>
          <xsl:value-of select="$label" disable-output-escaping="yes"/>
        </xsl:when>
        <xsl:otherwise> <!-- start looking in the Application -->

          <xsl:variable name="schemaName">
            <xsl:choose>
              <xsl:when test="contains($link, '.')"> <!--  Link contains schema -->
                <xsl:value-of select="substring-before($link, '.')" />
              </xsl:when>
              <xsl:otherwise>  
                  <xsl:value-of select="''" />
              </xsl:otherwise>  
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="methodName">
            <xsl:choose>
              <xsl:when test="contains($link, '#')"> <!--  Link contains schema -->
                <xsl:value-of select="substring-after($link, '#')" />
              </xsl:when>
              <xsl:otherwise>  
                <xsl:value-of select="''" />
              </xsl:otherwise>  
            </xsl:choose>
          </xsl:variable>
          <xsl:variable name="objectName">
            <xsl:value-of select="substring-before(substring-after($link, '.'),'#')" />
            <xsl:choose>
              <xsl:when test="contains($link, '.') and contains($link, '#')"> <!--  Link contains schema, object and method -->
                <xsl:value-of select="substring-after(substring-before($link, '#'),'.')" />
              </xsl:when>
              <xsl:when test="contains($link, '.')"> <!--  Link contains schema and object  -->
                <xsl:value-of select="substring-after($link,'.')" />
              </xsl:when>
              <xsl:when test="contains($link, '#')"> <!--  Link contains object and method -->
                <xsl:value-of select="substring-before($link, '#')" />
              </xsl:when>
              <xsl:otherwise>  
                <xsl:value-of select="$link" />
              </xsl:otherwise>  
            </xsl:choose>
          </xsl:variable>
          <!--
           <xsl:comment>
            schemaName=START<xsl:value-of select="$schemaName" disable-output-escaping="yes"/>END
            objectName=START<xsl:value-of select="$objectName" disable-output-escaping="yes"/>END
            methodName=START<xsl:value-of select="$methodName" disable-output-escaping="yes"/>END
          </xsl:comment>
          -->
          <xsl:choose>
            
            <xsl:when test="string-length($objectName) &gt; 0 and string-length($methodName) &gt; 0 and /APPLICATION/*[ translate(@NAME , $uppercase, $lowercase)= translate($objectName, $uppercase, $lowercase) ]/*[translate(@NAME , $uppercase, $lowercase) = translate($methodName , $uppercase, $lowercase)] ">
              <!--
                <xsl:comment>
                  matched objectName and methodName 
                  schemaName=START<xsl:value-of select="$schemaName" disable-output-escaping="yes"/>END
                  objectName=START<xsl:value-of select="$objectName" disable-output-escaping="yes"/>END
                  methodName=START<xsl:value-of select="$methodName" disable-output-escaping="yes"/>END
                </xsl:comment>
                -->
              <xsl:attribute name="href"><xsl:value-of select="translate(concat($objectName,'.html#',$methodName), $uppercase, $lowercase)" disable-output-escaping="yes"/></xsl:attribute>
                <xsl:value-of select="$label" disable-output-escaping="yes"/>
              </xsl:when>
            <!-- Attempt to match assuming that the link has been written as a normal PL/SQL entry (object_name.method_name) rather than object_name#method_name   
            -->
            <xsl:when test="string-length($schemaName) &gt; 0 and string-length($objectName) &gt; 0 and /APPLICATION/*[ translate(@NAME , $uppercase, $lowercase)= translate($schemaName, $uppercase, $lowercase) ]/*[translate(@NAME , $uppercase, $lowercase)= translate($objectName, $uppercase, $lowercase)] ">
              <!--
                <xsl:comment>
                matched on schemaName and objectName assuming that the link has been written as a normal PL/SQL entry (object_name.method_name) rather than object_name#method_name 
                schemaName=START<xsl:value-of select="$schemaName" disable-output-escaping="yes"/>END
                objectName=START<xsl:value-of select="$objectName" disable-output-escaping="yes"/>END
                methodName=START<xsl:value-of select="$methodName" disable-output-escaping="yes"/>END
                </xsl:comment>
              -->
              <xsl:attribute name="href"><xsl:value-of select="translate(concat($schemaName,'.html#',$objectName), $uppercase, $lowercase)" disable-output-escaping="yes"/></xsl:attribute>
              <xsl:value-of select="$label" disable-output-escaping="yes"/>
            </xsl:when>
            <xsl:when test="string-length($objectName) &gt; 0 and /APPLICATION/*[ translate(@NAME , $uppercase, $lowercase)= translate($objectName, $uppercase, $lowercase) ] ">
              <!--
                <xsl:comment>
                  matched objectName  
                  schemaName=START<xsl:value-of select="$schemaName" disable-output-escaping="yes"/>END
                  objectName=START<xsl:value-of select="$objectName" disable-output-escaping="yes"/>END
                  methodName=START<xsl:value-of select="$methodName" disable-output-escaping="yes"/>END
                </xsl:comment>
                -->
                <xsl:attribute name="href"><xsl:value-of select="translate($objectName, $uppercase, $lowercase)" disable-output-escaping="yes"/>.html</xsl:attribute>
                <xsl:value-of select="$label" disable-output-escaping="yes"/>
              </xsl:when>
              <xsl:otherwise>
                <!--
                <xsl:comment>
                  Failed to match with 
                  schemaName=START<xsl:value-of select="$schemaName" disable-output-escaping="yes"/>END
                  objectName=START<xsl:value-of select="$objectName" disable-output-escaping="yes"/>END
                  methodName=START<xsl:value-of select="$methodName" disable-output-escaping="yes"/>END
                  Assuming page internal link
                </xsl:comment>
                -->
                <xsl:attribute name="href"><xsl:value-of select="translate(concat('#',$link), $uppercase, $lowercase)" disable-output-escaping="yes"/></xsl:attribute>
                <xsl:value-of select="$label" disable-output-escaping="yes"/>
              </xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
    </A> 
  </xsl:template>
  <!-- -->
  
  <!-- ***************** processInlineTag - convert specifed inline tag in this text into HTML links ****************** -->
  <xsl:template name="processInlineTag">
    <xsl:param name="comment" />
    <xsl:param name="tag" />
    <xsl:variable name="tagStart">
      <xsl:value-of select="concat('{@',$tag)" />
    </xsl:variable>
    <!--
    <xsl:comment>
      LOOKING for TAG=<xsl:value-of select="$tag" /> in
      LOOKING for TAGSTART=<xsl:value-of select="$tagStart" /> in
      COMMENT==<xsl:value-of select="$comment" />
    </xsl:comment>
    -->
    <xsl:choose>
      <xsl:when test="contains($comment, $tagStart )"  >
        <!-- Process the bit before the tag -->
        <!--
        <xsl:comment>
          Bit before linkTag=START<xsl:value-of select="substring-before($comment, $tagStart)" disable-output-escaping="yes"/>END
        </xsl:comment>
        -->
        <xsl:value-of select="substring-before($comment, $tagStart)" disable-output-escaping="yes"/>
        <!-- Process the the tag text -->
        <xsl:variable name="linkTag">
          <!-- <xsl:value-of select="substring-after(substring-before($comment, '}' ),$tagStart)" /> -->
          <!-- Trim the tag - also normalises spaces in the string -->
          <xsl:value-of select="normalize-space(substring-after(substring-before($comment, '}' ),$tagStart))" />
        </xsl:variable>
        <!--
        <xsl:comment>
          linkTag=START<xsl:value-of select="$linkTag" />END
        </xsl:comment>
        -->
        <xsl:choose>
          <xsl:when test="contains($linkTag, ' ') "  > <!-- normalize-space(string) $linkTag contains a space -->
            <!--
            <xsl:comment>
              link=START<xsl:value-of select="substring-before($linkTag, ' ')" />END
              label=START<xsl:value-of select="substring-after($linkTag, ' ')" />END
            </xsl:comment>
            -->
            <xsl:call-template name="LinkTagToLink">
              <xsl:with-param name="link" select="substring-before($linkTag, ' ')" />
              <xsl:with-param name="label" select="substring-after($linkTag, ' ')" />
            </xsl:call-template>
          </xsl:when >
          <xsl:otherwise >
            <!--
            <xsl:comment>
              link=START<xsl:value-of select="$linkTag" />END
              label=START<xsl:value-of select="$linkTag" />END
            </xsl:comment>
            -->
            <xsl:call-template name="LinkTagToLink">
              <xsl:with-param name="link" select="$linkTag" />
              <xsl:with-param name="label" select="$linkTag" />
            </xsl:call-template>
          </xsl:otherwise >
        </xsl:choose>
        
        <!-- Recursively call processInlineTag on the bit left over-->
        <!--
        <xsl:comment>
          Bit after linkTag=START<xsl:value-of select="substring-after($comment, '}')" />END
        </xsl:comment>
        -->
        <xsl:call-template name="processInlineTag">
          <xsl:with-param name="comment" select="substring-after($comment, '}')" />
          <xsl:with-param name="tag" select="$tag"/>
        </xsl:call-template>
        
      </xsl:when>
      <xsl:otherwise> <!-- The fragment does not contain the specifed link-->
        <xsl:value-of select="$comment" disable-output-escaping="yes"/>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:template>
    <!-- -->
    
    
  <!-- ***************** METHOD/TYPE/TRIGGER SUMMARY TEMPLATE ****************** -->
  <xsl:template name="MethodOrTypeOrTriggerSummary">
    <xsl:param name="fragmentName" />
    <xsl:param name="title" />
    <xsl:param name="mainTags" />
    <xsl:param name="childTags" />
    <xsl:param name="flagTrigger" />

    <A NAME="{$fragmentName}"></A>
    <xsl:if test="$mainTags">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="2"><FONT SIZE="+2">
    <B><xsl:value-of select="$title"/></B></FONT></TD>
    </TR>

    <xsl:for-each select="$mainTags">
      <xsl:sort select="@NAME"/>
      <TR CLASS="TableRowColor">
      <TD ALIGN="right" VALIGN="top" WIDTH="1%"><FONT SIZE="-1">
      <CODE><xsl:text>&nbsp;</xsl:text>
      <!-- 20110428 <xsl:value-of select="RETURN/@TYPE"/> -->
      <!-- If possible, convert the plain-text TYPE to a link to a matching OBJECT TYPE in the Application-->
	    <xsl:variable name="fieldType" select="translate(RETURN/@TYPE, $uppercase, $lowercase)" />
      <xsl:call-template name="GenerateTypeLink">
	    <xsl:with-param name="typeName" select="RETURN/@TYPE" />
            <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
            <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME" />
      </xsl:call-template>
      </CODE></FONT></TD>
	<xsl:variable name="nameLowerCase" select="translate(@NAME, $uppercase, $lowercase)" />
	<xsl:comment> 
		siblingCount=<xsl:value-of select="count(preceding-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase) ]) + count(following-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase)])" /> 
		argumentCount=<xsl:value-of select="count(ARGUMENT)" /> 
		predecessorCount=<xsl:value-of select="count(preceding-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase)])" /> 
		siblingNoArgumentCount=<xsl:value-of select="count(preceding-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase) and not(ARGUMENT) ]) + count(following-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase) and not(ARGUMENT) ])" /> 
	</xsl:comment>
	<xsl:variable name="arguments" select="count(ARGUMENT)" /> 
	<xsl:variable name="predecessors" select="count(preceding-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase)])" /> 
	<xsl:variable name="siblingsWithoutArguments" select="count(preceding-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase) and not(ARGUMENT) ]) + count(following-sibling::*[$nameLowerCase = translate(@NAME,$uppercase,$lowercase) and not(ARGUMENT) ])" /> 
	<xsl:if test="$arguments > 0 and $predecessors = 0 and $siblingsWithoutArguments = 0" >
	<xsl:element name="A"><xsl:attribute name="NAME"><xsl:value-of select="$nameLowerCase" /></xsl:attribute></xsl:element>
	</xsl:if>
      <TD><CODE>
        <B><xsl:element name="A"><xsl:attribute name="HREF">#<xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" />
        <xsl:if test="*[name()=$childTags]">
        <xsl:text>(</xsl:text>
        <xsl:for-each select="*[name()=$childTags]">
          <xsl:value-of select="translate(@TYPE, $uppercase, $lowercase)"/>
          <xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
        </xsl:if>
        </xsl:attribute><xsl:value-of select="@NAME"/></xsl:element></B>
        <xsl:if test="not($flagTrigger)"><xsl:text>(</xsl:text></xsl:if>
        <xsl:for-each select="*[name()=$childTags]">
          <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/>
          <xsl:if test="string-length(@MODE) &gt; 0">
            <xsl:text> </xsl:text><xsl:value-of select="@MODE"/>
          </xsl:if>
          <xsl:text> </xsl:text><xsl:value-of select="@TYPE"/>
          <xsl:if test="string-length(@DEFAULT) &gt; 0">
            <xsl:text> DEFAULT </xsl:text><xsl:value-of select="@DEFAULT"/>
          </xsl:if>
          <xsl:if test="not(position()=last())"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:if test="not($flagTrigger)"><xsl:text>)</xsl:text></xsl:if>
        </CODE>
      <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
        <xsl:for-each select="COMMENT_FIRST_LINE">
          <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <B>Deprecated.</B>&nbsp;<I>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each></I>
      </xsl:for-each>
      </TD>
      </TR>
    </xsl:for-each>

    </TABLE>
    <P/>

    </xsl:if>
  </xsl:template>

  <!-- ************************* METHOD/TYPE/TRIGGER DETAIL TEMPLATE *************************** -->
  <xsl:template name="MethodOrTypeOrTriggerDetail">
    <xsl:param name="fragmentName" />
    <xsl:param name="title" />
    <xsl:param name="mainTags" />
    <xsl:param name="childTags" />
    <xsl:param name="flagTrigger" />
    <xsl:param name="childDescription" /> <!-- 11G Trigger Changes-->
    
    <A NAME="{$fragmentName}"></A>
    <xsl:if test="$mainTags">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="1"><FONT SIZE="+2">
    <B><xsl:value-of select="$title"/></B></FONT></TD>
    </TR>
    </TABLE>

    <xsl:for-each select="$mainTags">
      <xsl:sort select="@NAME"/>
      <xsl:element name="A"><xsl:attribute name="NAME"><xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" />
        <xsl:if test="*[name()=$childTags]">
        <xsl:text>(</xsl:text>
        <xsl:for-each select="*[name()=$childTags]">
          <xsl:value-of select="translate(@TYPE, $uppercase, $lowercase)"/>
          <xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
        </xsl:if>
        </xsl:attribute></xsl:element>
      <H3><xsl:value-of select="@NAME"/></H3>
      <PRE>
        <xsl:variable name="methodText">
		<xsl:if test="not($flagTrigger)">public</xsl:if><xsl:text> </xsl:text><xsl:value-of select="RETURN/@TYPE"/><xsl:text> </xsl:text><B><xsl:value-of select="@NAME"/></B>
        </xsl:variable>
        <xsl:variable name="methodTextString" select="java:lang.String.new($methodText)"/>
	<xsl:if test="not($flagTrigger)">public</xsl:if><xsl:text> </xsl:text>
      <!-- 20110428 <xsl:value-of select="RETURN/@TYPE"/> -->
      <!-- If possible, convert the plain-text TYPE to a link to a matching OBJECT TYPE in the Application-->
      <xsl:variable name="fieldType" select="translate(RETURN/@TYPE, $uppercase, $lowercase)" />
      <xsl:call-template name="GenerateTypeLink">
	    <xsl:with-param name="typeName" select="RETURN/@TYPE" />
            <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
            <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME " />
      </xsl:call-template><xsl:text> </xsl:text><B><xsl:value-of select="@NAME"/></B>
          <xsl:if test="not($flagTrigger)">
	        <xsl:text>(</xsl:text>
	        <xsl:for-each select="*[name()=$childTags]">
	          <!-- pad arguments with appropriate number of spaces -->
	          <xsl:if test="not(position()=1)"><BR/><xsl:value-of select="str:padding(java:length($methodTextString)+1)"/></xsl:if>
	          <xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/>
	          <xsl:if test="string-length(@MODE) &gt; 0">
	            <xsl:text> </xsl:text><xsl:value-of select="@MODE"/>
	          </xsl:if>
	          <xsl:text> </xsl:text><xsl:value-of select="@TYPE"/>
	          <xsl:if test="string-length(@DEFAULT) &gt; 0">
	            <xsl:text> DEFAULT </xsl:text><xsl:value-of select="@DEFAULT"/>
	          </xsl:if>
	          <xsl:if test="not(position()=last())"><xsl:text>, </xsl:text></xsl:if>
	        </xsl:for-each>
	        <xsl:text>)</xsl:text>
          </xsl:if>
      </PRE>
      
      <DL>

      <DD>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </DD>

      <DD><DL>
        <xsl:if test="*[name()=$childTags][COMMENT]">
        <DT><xsl:value-of select="$childDescription"/>:
        <xsl:for-each select="*[name()=$childTags]">
          <xsl:if test="COMMENT">
            <DD><CODE><xsl:value-of select="translate(@NAME, $uppercase, $lowercase)"/></CODE> -
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
          </xsl:if>
        </xsl:for-each>
        </DT>
        </xsl:if>
        <xsl:for-each select="RETURN/COMMENT">
        <DT>Returns:
          <DD>
            <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
            <xsl:call-template name="processInlineTag">
              <xsl:with-param name="comment" select="." />
              <xsl:with-param name="tag" select="'link'" />
            </xsl:call-template>
          </DD>
        </DT>
        </xsl:for-each>
        <xsl:if test="THROWS">
        <DT>Throws:
        <xsl:for-each select="THROWS">
            <DD><CODE><xsl:value-of select="@NAME"/></CODE> -
              <xsl:for-each select="COMMENT">
                <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
                <xsl:call-template name="processInlineTag">
                  <xsl:with-param name="comment" select="." />
                  <xsl:with-param name="tag" select="'link'" />
                </xsl:call-template>
              </xsl:for-each>
            </DD>
        </xsl:for-each>
        </DT>
        </xsl:if>

		  <!-- triggers only -->
	      <xsl:if test="DECLARATION">
			<DT>Declaration:</DT>
	        <DD>
	          <xsl:value-of select="DECLARATION/@TEXT" disable-output-escaping="yes" />
	        </DD>
	      </xsl:if>
        
    </DL></DD>

	<!-- print custom tags --> 
	<P/>   
    <xsl:call-template name="CustomTagsTemplate"/>
    
    </DL>

    <HR/>
    </xsl:for-each>

    </xsl:if>
  </xsl:template>

  <!-- ************************* START OF PAGE ***************************** -->
  <xsl:template match="/APPLICATION">
  <!-- ********************* START OF top-level object PAGE ************************* -->
  <!--<xsl:for-each select="PACKAGE | PACKAGE_BODY">-->
  <xsl:for-each select="PACKAGE | OBJECT_TYPE | TRIGGER">

    <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

    <HTML>
    <HEAD>
      <TITLE><xsl:value-of select="../@NAME"/></TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
    </HEAD>
    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
    <xsl:call-template name="NavigationBar"/>

    <!-- ********************** PACKAGE DESCRIPTION ************************* -->
    <H2>
    <FONT SIZE="-1"><xsl:value-of select="@SCHEMA"/></FONT><BR/>
     <xsl:choose>
	     <xsl:when test="local-name() = 'OBJECT_TYPE'">
	     <xsl:choose>
		     <xsl:when test="./COLLECTIONTYPE">Object Collection</xsl:when>
		     <xsl:when test="./SUPERTYPE">Subtype</xsl:when>
		     <xsl:otherwise>Object Type</xsl:otherwise>
	      </xsl:choose>
	     </xsl:when>
	      <xsl:otherwise>Package</xsl:otherwise>
      </xsl:choose><xsl:text>&nbsp;</xsl:text><xsl:value-of select="@NAME"/>
    </H2>

	<!-- package comment -->
    <xsl:for-each select="COMMENT">
      <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
      <xsl:call-template name="processInlineTag">
        <xsl:with-param name="comment" select="." />
        <xsl:with-param name="tag" select="'link'" />
      </xsl:call-template>
    </xsl:for-each>

	<P/>
	
	<!-- print custom tags -->    
    <xsl:call-template name="CustomTagsTemplate"/>

    <HR/>
    <P/>

    <!-- ************************** FIELD SUMMARY ************************** -->
    <A NAME="field_summary"></A>
    <xsl:if test="CONSTANT | VARIABLE | SUPERTYPE">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="2"><FONT SIZE="+2">
    <B>Field Summary</B></FONT></TD>
    </TR>

    <xsl:for-each select="CONSTANT | VARIABLE | SUPERTYPE">
      <xsl:sort select="@NAME"/>
      <TR CLASS="TableRowColor">
      <TD ALIGN="right" VALIGN="top" WIDTH="1%"><FONT SIZE="-1">
      <CODE><xsl:text>&nbsp;</xsl:text>
      <!-- If possible, convert the plain-text NAME to a link to a matching OBJECT TYPE in the Application-->
      <xsl:choose>
	      <xsl:when test="local-name() = 'SUPERTYPE'">
		      <!--<xsl:when test="local-name() = 'SUPERTYPE' and /APPLICATION/OBJECT_TYPE[@NAME=./@NAME] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" disable-output-escaping="yes"/>.html</xsl:attribute>
		<xsl:value-of select="@NAME" disable-output-escaping="yes"/>
            </A>
	      <!- - If possible, convert the plain-text TYPE to a link to a matching OBJECT TYPE in the Application-->
	    <xsl:variable name="fieldType" select="translate(@NAME, $uppercase, $lowercase)" />
	      <xsl:call-template name="GenerateTypeLink">
		    <xsl:with-param name="typeName" select="@NAME" />
		    <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
                    <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME " />
	      </xsl:call-template>
       </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="fieldType" select="translate(RETURN/@TYPE, $uppercase, $lowercase)" />
	      <xsl:call-template name="GenerateTypeLink">
		    <xsl:with-param name="typeName" select="RETURN/@TYPE" />
		    <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
                    <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME " />
	      </xsl:call-template>
	  </xsl:otherwise>
      </xsl:choose>
      </CODE></FONT></TD>
      <TD><CODE>
      <xsl:choose>
	  <xsl:when test="local-name() = 'SUPERTYPE'">SUPERTYPE</xsl:when>
	  <xsl:otherwise>
		      <B><A HREF="#{@NAME}"><xsl:value-of select="@NAME"/></A></B>
	  </xsl:otherwise>
      </xsl:choose>
	 <xsl:if test="local-name() = 'CONSTANT'"> CONSTANT</xsl:if>
	 <xsl:if test="@DEFAULT"> := <xsl:value-of select="@DEFAULT" disable-output-escaping="yes" /></xsl:if>
        </CODE>
      <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
        <xsl:for-each select="COMMENT_FIRST_LINE">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <B>Deprecated.</B>&nbsp;<I>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each></I>
      </xsl:for-each>
      </TD>
      </TR>
    </xsl:for-each>

    </TABLE>
    <P/>

    </xsl:if>

    <!-- ************************* TYPE SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">type_summary</xsl:with-param>
      <xsl:with-param name="title">Type Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="TYPE" />
      <xsl:with-param name="childTags" select="'FIELD'" />
    </xsl:call-template>

    <!-- ************************* METHOD SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">method_summary</xsl:with-param>
      <xsl:with-param name="title">Method Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE" />
      <xsl:with-param name="childTags" select="'ARGUMENT'" />
    </xsl:call-template>

    <!-- ************************* TRIGGER SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">trigger_summary</xsl:with-param>
      <xsl:with-param name="title">Trigger Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="TRIGGER" />
      <xsl:with-param name="childTags" select="'TIMINGPOINTSECTION'" /> <!-- 11 G Trigger Syntax -->
      <xsl:with-param name="flagTrigger" select="'TRUE'" /> 
    </xsl:call-template>

    <!-- ************************** FIELD DETAIL *************************** -->
    <A NAME="field_detail"></A>
    <xsl:if test="CONSTANT | VARIABLE">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="1"><FONT SIZE="+2">
    <B>Field Detail</B></FONT></TD>
    </TR>
    </TABLE>

    <xsl:for-each select="CONSTANT | VARIABLE">
      <xsl:sort select="@NAME"/>
      <A NAME="{@NAME}"></A><H3><xsl:value-of select="@NAME"/></H3>
      <PRE>
  public <xsl:value-of select="RETURN/@TYPE"/><xsl:text> </xsl:text><B><xsl:value-of select="@NAME"/></B>
	 <xsl:if test="local-name() = 'CONSTANT'"> CONSTANT</xsl:if>
	 <xsl:if test="@DEFAULT"> := <xsl:value-of select="@DEFAULT" disable-output-escaping="yes" /></xsl:if>
      </PRE>
      <DL>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <DD><B>Deprecated.</B>&nbsp;<I>
          <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
          </xsl:for-each></I>
        </DD><P/>
      </xsl:for-each>
      <DD>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </DD>

      <DD><DL>
    </DL>
    </DD>
    </DL>

    <HR/>
    </xsl:for-each>

    </xsl:if>

    <!-- ************************* TYPE DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">type_detail</xsl:with-param>
      <xsl:with-param name="title">Type Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="TYPE" />
      <xsl:with-param name="childTags" select="'FIELD'" />
      <xsl:with-param name="childDescription" select="'Parameters'"/>
    </xsl:call-template>

    <!-- ************************* METHOD DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">method_detail</xsl:with-param>
      <xsl:with-param name="title">Method Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE" />
      <xsl:with-param name="childTags" select="'ARGUMENT'" />
      <xsl:with-param name="childDescription" select="'Parameters'"/>
    </xsl:call-template>

    <!-- ************************* TRIGGER DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">trigger_detail</xsl:with-param>
      <xsl:with-param name="title">Trigger Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="TRIGGER" />
      <xsl:with-param name="childTags" select="'TIMINGPOINTSECTION'" />
      <xsl:with-param name="flagTrigger" select="'TRUE'" /> 
      <xsl:with-param name="childDescription" select="'Timing Points'"/>
    </xsl:call-template>

    <!-- ***************************** FOOTER ****************************** -->
    <xsl:call-template name="NavigationBar"/>

    </BODY>
    </HTML>

    </redirect:write>
  </xsl:for-each> <!-- select="PACKAGE | PACKAGE_BODY" -->

  <!--<xsl:for-each BODY object">
    This is cut and paste of the callable Oracle Object XSLT with the exception of the output file name  
  -->
  <xsl:for-each select="PACKAGE_BODY | OBJECT_BODY">

    <redirect:write file="{concat($targetFolder, '_', translate(@NAME, $uppercase, $lowercase))}_body.html">

    <HTML>
    <HEAD>
      <TITLE><xsl:value-of select="../@NAME"/></TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
    </HEAD>
    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
    <xsl:call-template name="NavigationBar"/>

    <!-- ********************** PACKAGE DESCRIPTION ************************* -->
    <H2>
    <FONT SIZE="-1"><xsl:value-of select="@SCHEMA"/></FONT><BR/>
     <xsl:choose>
	     <xsl:when test="local-name() = 'OBJECT_BODY'">
	     <xsl:choose>
		     <xsl:when test="./COLLECTIONTYPE">Object Collection</xsl:when>
		     <xsl:when test="./SUPERTYPE">Subtype</xsl:when>
		     <xsl:otherwise>Object Type</xsl:otherwise>
	      </xsl:choose>
	     </xsl:when>
	      <xsl:otherwise>Package</xsl:otherwise>
      </xsl:choose><xsl:text>&nbsp;</xsl:text><xsl:value-of select="@NAME"/>
    </H2>

	<!-- package comment -->
    <xsl:for-each select="COMMENT">
      <!-- SRT 20110501 <xsl:value-of select="." disable-output-escaping="yes" /> -->
      <xsl:call-template name="processInlineTag">
        <xsl:with-param name="comment" select="." />
        <xsl:with-param name="tag" select="'link'" />
      </xsl:call-template>
    </xsl:for-each>

	<P/>
	
	<!-- print custom tags -->    
    <xsl:call-template name="CustomTagsTemplate"/>

    <HR/>
    <P/>

    <!-- ************************** FIELD SUMMARY ************************** -->
    <A NAME="field_summary"></A>
    <xsl:if test="CONSTANT | VARIABLE | SUPERTYPE">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="2"><FONT SIZE="+2">
    <B>Field Summary</B></FONT></TD>
    </TR>

    <xsl:for-each select="CONSTANT | VARIABLE | SUPERTYPE">
      <xsl:sort select="@NAME"/>
      <TR CLASS="TableRowColor">
      <TD ALIGN="right" VALIGN="top" WIDTH="1%"><FONT SIZE="-1">
      <CODE><xsl:text>&nbsp;</xsl:text>
      <!-- If possible, convert the plain-text NAME to a link to a matching OBJECT TYPE in the Application-->
      <xsl:choose>
	      <xsl:when test="local-name() = 'SUPERTYPE'">
		      <!--<xsl:when test="local-name() = 'SUPERTYPE' and /APPLICATION/OBJECT_TYPE[@NAME=./@NAME] ">
	    <A>
		<xsl:attribute name="href"><xsl:value-of select="translate(@NAME, $uppercase, $lowercase)" disable-output-escaping="yes"/>.html</xsl:attribute>
		<xsl:value-of select="@NAME" disable-output-escaping="yes"/>
            </A>
	      <!- - If possible, convert the plain-text TYPE to a link to a matching OBJECT TYPE in the Application-->
	    <xsl:variable name="fieldType" select="translate(@NAME, $uppercase, $lowercase)" />
	      <xsl:call-template name="GenerateTypeLink">
		    <xsl:with-param name="typeName" select="@NAME" />
		    <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
                    <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME " />
	      </xsl:call-template>
       </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="fieldType" select="translate(RETURN/@TYPE, $uppercase, $lowercase)" />
	      <xsl:call-template name="GenerateTypeLink">
		    <xsl:with-param name="typeName" select="RETURN/@TYPE" />
		    <xsl:with-param name="schemaName" select="ancestor-or-self::*/@SCHEMA"/>
                    <xsl:with-param name="localTypeName" select="../TYPE[ translate(@NAME, $uppercase, $lowercase) = $fieldType ]/@NAME " />
	      </xsl:call-template>
	  </xsl:otherwise>
      </xsl:choose>
      </CODE></FONT></TD>
      <TD><CODE>
      <xsl:choose>
	  <xsl:when test="local-name() = 'SUPERTYPE'">SUPERTYPE</xsl:when>
	  <xsl:otherwise>
		      <B><A HREF="#{@NAME}"><xsl:value-of select="@NAME"/></A></B>
	  </xsl:otherwise>
      </xsl:choose>
	 <xsl:if test="local-name() = 'CONSTANT'"> CONSTANT</xsl:if>
	 <xsl:if test="@DEFAULT"> := <xsl:value-of select="@DEFAULT" disable-output-escaping="yes" /></xsl:if>
        </CODE>
      <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
        <xsl:for-each select="COMMENT_FIRST_LINE">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <B>Deprecated.</B>&nbsp;<I>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each></I>
      </xsl:for-each>
      </TD>
      </TR>
    </xsl:for-each>

    </TABLE>
    <P/>

    </xsl:if>

    <!-- ************************* TYPE SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">type_summary</xsl:with-param>
      <xsl:with-param name="title">Type Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="TYPE" />
      <xsl:with-param name="childTags" select="'FIELD'" />
    </xsl:call-template>

    <!-- ************************* METHOD SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">method_summary</xsl:with-param>
      <xsl:with-param name="title">Method Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE" />
      <xsl:with-param name="childTags" select="'ARGUMENT'" />
    </xsl:call-template>

    <!-- ************************* TRIGGER SUMMARY ************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerSummary">
      <xsl:with-param name="fragmentName">trigger_summary</xsl:with-param>
      <xsl:with-param name="title">Trigger Summary</xsl:with-param>
      <xsl:with-param name="mainTags" select="TRIGGER" />
      <xsl:with-param name="childTags" select="'TIMINGPOINTSECTION'" /> <!-- 11 G Trigger Syntax -->
      <xsl:with-param name="flagTrigger" select="'TRUE'" /> 
    </xsl:call-template>

    <!-- ************************** FIELD DETAIL *************************** -->
    <A NAME="field_detail"></A>
    <xsl:if test="CONSTANT | VARIABLE">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="1"><FONT SIZE="+2">
    <B>Field Detail</B></FONT></TD>
    </TR>
    </TABLE>

    <xsl:for-each select="CONSTANT | VARIABLE">
      <xsl:sort select="@NAME"/>
      <A NAME="{@NAME}"></A><H3><xsl:value-of select="@NAME"/></H3>
      <PRE>
  public <xsl:value-of select="RETURN/@TYPE"/><xsl:text> </xsl:text><B><xsl:value-of select="@NAME"/></B>
	 <xsl:if test="local-name() = 'CONSTANT'"> CONSTANT</xsl:if>
	 <xsl:if test="@DEFAULT"> := <xsl:value-of select="@DEFAULT" disable-output-escaping="yes" /></xsl:if>
      </PRE>
      <DL>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <DD><B>Deprecated.</B>&nbsp;<I>
          <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
          </xsl:for-each></I>
        </DD><P/>
      </xsl:for-each>
      <DD>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </DD>

      <DD><DL>
    </DL>
    </DD>
    </DL>

    <HR/>
    </xsl:for-each>

    </xsl:if>

    <!-- ************************* TYPE DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">type_detail</xsl:with-param>
      <xsl:with-param name="title">Type Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="TYPE" />
      <xsl:with-param name="childTags" select="'FIELD'" />
      <xsl:with-param name="childDescription" select="'Parameters'"/>
    </xsl:call-template>

    <!-- ************************* METHOD DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">method_detail</xsl:with-param>
      <xsl:with-param name="title">Method Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="FUNCTION | PROCEDURE" />
      <xsl:with-param name="childTags" select="'ARGUMENT'" />
      <xsl:with-param name="childDescription" select="'Parameters'"/>
    </xsl:call-template>

    <!-- ************************* TRIGGER DETAIL *************************** -->
    <xsl:call-template name="MethodOrTypeOrTriggerDetail">
      <xsl:with-param name="fragmentName">trigger_detail</xsl:with-param>
      <xsl:with-param name="title">Trigger Detail</xsl:with-param>
      <xsl:with-param name="mainTags" select="TRIGGER" />
      <xsl:with-param name="childTags" select="'TIMINGPOINTSECTION'" />
      <xsl:with-param name="flagTrigger" select="'TRUE'" /> 
      <xsl:with-param name="childDescription" select="'Timing Points'"/>
    </xsl:call-template>

    <!-- ***************************** FOOTER ****************************** -->
    <xsl:call-template name="NavigationBar"/>

    </BODY>
    </HTML>

    </redirect:write>
  </xsl:for-each> <!-- select="PACKAGE | PACKAGE_BODY" -->

  <!--<xsl:for-each BODY">-->

  <!-- ********************** START OF TABLE PAGE ************************** -->
  <xsl:for-each select="TABLE | VIEW">

    <redirect:write file="{concat($targetFolder, translate(@NAME, $uppercase, $lowercase))}.html">

    <HTML>
    <HEAD>
      <TITLE><xsl:value-of select="../@NAME"/></TITLE>
      <LINK REL="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style"/>
    </HEAD>
    <BODY BGCOLOR="white">

    <!-- **************************** HEADER ******************************* -->
    <xsl:call-template name="NavigationBar"/>

    <!-- ********************** TABLE DECRIPTION ************************* -->
    <H2>
    <FONT SIZE="-1"><xsl:value-of select="@SCHEMA"/></FONT><BR/>
    <xsl:value-of select="local-name(.)"/><xsl:text> </xsl:text><xsl:value-of select="@NAME"/>
    </H2>
    <xsl:for-each select="TAG[@TYPE='@deprecated']">
      <P>
      <B>Deprecated.</B>&nbsp;<I>
      <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
      </xsl:for-each></I>
      </P>
    </xsl:for-each>
    <P>
    <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
    </xsl:for-each>
    </P>
    <HR/>
    <P/>

    <!-- ***************************** COLUMNS ***************************** -->
    <A NAME="field_summary"></A>
    <xsl:if test="COLUMN">

    <TABLE BORDER="1" CELLPADDING="3" CELLSPACING="0" WIDTH="100%">
    <TR CLASS="TableHeadingColor">
    <TD COLSPAN="2"><FONT SIZE="+2">
    <B>Columns</B></FONT></TD>
    </TR>

    <xsl:for-each select="COLUMN">
      <TR CLASS="TableRowColor">
      <TD ALIGN="right" VALIGN="top" WIDTH="1%"><FONT SIZE="-1">
      <CODE><xsl:text>&nbsp;</xsl:text>
      <xsl:value-of select="@TYPE"/>
      </CODE></FONT></TD>
      <TD><CODE><B><A HREF="#{@NAME}">
        <xsl:value-of select="@NAME"/></A></B>
        </CODE>
      <BR/>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <xsl:if test="not(./TAG[@TYPE='@deprecated'])">
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each>
      </xsl:if>
      <xsl:for-each select="TAG[@TYPE='@deprecated']">
        <B>Deprecated.</B>&nbsp;<I>
        <xsl:for-each select="COMMENT">
          <!-- SRT 20110509 <xsl:value-of select="." disable-output-escaping="yes" /> -->
          <xsl:call-template name="processInlineTag">
            <xsl:with-param name="comment" select="." />
            <xsl:with-param name="tag" select="'link'" />
          </xsl:call-template>
        </xsl:for-each></I>
      </xsl:for-each>
      </TD>
      </TR>
    </xsl:for-each>

    </TABLE>
    <P/>

    </xsl:if>

    <!-- ***************************** FOOTER ****************************** -->
    <xsl:call-template name="NavigationBar"/>

    </BODY>
    </HTML>

    </redirect:write>
  </xsl:for-each> <!-- select="TABLE" -->

  </xsl:template>

</xsl:stylesheet>
