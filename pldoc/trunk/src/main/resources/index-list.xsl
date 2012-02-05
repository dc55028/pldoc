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

<!DOCTYPE xsl:stylesheet [
<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:java="java"
  xmlns:exslt="http://exslt.org/common"
  xmlns:str="http://exslt.org/strings"
  xmlns:lxslt="http://xml.apache.org/xslt"
  extension-element-prefixes="str java">

  <xsl:output method="html" indent="yes"/>

  <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
  <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
	
	
	<!-- Issue 3477662 -->
	<xsl:variable name="samecase">ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz</xsl:variable>
	<xsl:variable name="namesLowerCase" select="/APPLICATION/GENERATOR/SETTINGS/@NAMES_TO_LOWER_CASE" />
	<xsl:variable name="namesUpperCase" select="/APPLICATION/GENERATOR/SETTINGS/@NAMES_TO_UPPER_CASE" />
	<xsl:variable name="namesDefaultCase" select="/APPLICATION/GENERATOR/SETTINGS/@NAMES_TO_DEFAULT_CASE" />
	<xsl:variable name="defaultNamesCase" select="/APPLICATION/GENERATOR/SETTINGS/@DEFAULT_NAMES_CASE" />
	<xsl:variable name="namesFromCase" >
		<xsl:choose>
			<xsl:when test="$namesLowerCase='TRUE'" >
				<xsl:value-of select="$uppercase" />
			</xsl:when>
			<xsl:when test="$namesUpperCase='TRUE'" >
				<xsl:value-of select="$lowercase" />
			</xsl:when>
			<xsl:when test="$namesDefaultCase='TRUE'" >
				<xsl:value-of select="$samecase" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$samecase" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="namesToCase" >
		<xsl:choose>
			<xsl:when test="$namesLowerCase='TRUE'" >
				<xsl:value-of select="$lowercase" />
			</xsl:when>
			<xsl:when test="$namesUpperCase='TRUE'" >
				<xsl:value-of select="$uppercase" />
			</xsl:when>
			<xsl:when test="$namesDefaultCase='TRUE'" >
				<xsl:value-of select="$samecase" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$samecase" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Issue 3477662 -->
	
	<!-- ***************** string-replace-all - perform case insensitive replace ****************** -->
	<xsl:template name="string-replace-all">
		<xsl:param name="text"/>
		<xsl:param name="replace"/>
		<xsl:param name="by"/>
		<xsl:variable name="lowerCaseText" select="translate($text, $uppercase, $lowercase)" />
		<xsl:variable name="lowerCaseReplace" select="translate($replace, $uppercase, $lowercase)" />
		<xsl:choose>
			<xsl:when test="contains($lowerCaseText,$lowerCaseReplace)">
				<xsl:variable name="preMatchLength" select="string-length(substring-before($lowerCaseText,$lowerCaseReplace))" />
				<xsl:value-of select="substring($text,1,$preMatchLength)" disable-output-escaping="yes" />
				<xsl:copy-of select="$by" />
				<xsl:call-template name="string-replace-all">
					<xsl:with-param name="text" select="substring($text,($preMatchLength + string-length($replace) + 1 ) )"/>
					<xsl:with-param name="replace" select="$replace"/>
					<xsl:with-param name="by" select="$by"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text" disable-output-escaping="yes" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<!-- End of String Replace -->	
	
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
							<xsl:attribute name="href"><xsl:value-of select="translate(concat($objectName,'.html#',$methodName), $namesFromCase, $namesToCase)" disable-output-escaping="yes"/></xsl:attribute>
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
							<xsl:attribute name="href"><xsl:value-of select="translate(concat($schemaName,'.html#',$objectName), $namesFromCase, $namesToCase)" disable-output-escaping="yes"/></xsl:attribute>
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
							<xsl:attribute name="href"><xsl:value-of select="translate($objectName, $namesFromCase, $namesToCase)" disable-output-escaping="yes"/>.html</xsl:attribute>
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
							<xsl:attribute name="href"><xsl:value-of select="translate(concat('#',$link),  $namesFromCase, $namesToCase)" disable-output-escaping="yes"/></xsl:attribute>
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
      COMMENT-NODES==<xsl:value-of select="count(exslt:node-set($comment))" />
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
				<xsl:value-of select="substring-before($comment, $tagStart)" disable-output-escaping="yes" />
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
					</xsl:when>
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
					<xsl:with-param name="comment" select="exslt:node-set(substring-after($comment, '}'))" />
					<xsl:with-param name="tag" select="$tag"/>
				</xsl:call-template>
				
			</xsl:when>
			<xsl:otherwise> <!-- The fragment does not contain the specifed link-->
				<xsl:choose>
					<xsl:when test="exslt:node-set($comment)/*" >
						<xsl:copy-of select="$comment" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$comment" disable-output-escaping="yes" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- -->
  <xsl:key name="schemaInit" match="*[@SCHEMA]" use="@SCHEMA"/>

  <!-- ********************** NAVIGATION BAR TEMPLATE ********************** -->
  <xsl:template name="NavigationBar">
    <TABLE BORDER="0" WIDTH="100%" CELLPADDING="1" CELLSPACING="0">
    <TR>
    <TD COLSPAN="2" CLASS="NavBarRow1">
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="3">
      <TR ALIGN="center" VALIGN="top">
      <TD CLASS="NavBarRow1"><A HREF="summary.html"><FONT CLASS="NavBarFont1"><B>Overview</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="deprecated-list.html"><FONT CLASS="NavBarFont1"><B>Deprecated</B></FONT></A> &nbsp;</TD>
      <TD CLASS="NavBarRow1Chosen"><FONT CLASS="NavBarFont1Chosen"><B>Index</B></FONT> &nbsp;</TD>
      <TD CLASS="NavBarRow1"><A HREF="generator.html"><FONT CLASS="NavBarFont1"><B>Generator</B></FONT></A> &nbsp;</TD>
      </TR>
    </TABLE>
    </TD>
    <TD ALIGN="right" VALIGN="top" rowspan="3"><EM>
      <b><xsl:value-of select="@NAME"/></b></EM>
    </TD>
    </TR>

    </TABLE>
    <HR/>
  </xsl:template>

  <!-- ************************* INDEX GROUP ***************************** -->
	<xsl:template name="IndexGroup">
    <xsl:param name="indexChar" />

    <DL>
		  <DT>
		  	<!-- anchor -->
		    <xsl:element name="A">
	        <xsl:attribute name="NAME"><xsl:value-of select="$indexChar"/></xsl:attribute>
				</xsl:element>
				<xsl:value-of select="$indexChar"/>
			</DT>
			
			<xsl:for-each select="OBJECT_TYPE/child::*">
		  	<xsl:sort select="translate(@NAME, $namesFromCase, $namesToCase)"/>
				
				<xsl:if test="starts-with(translate(substring(@NAME, 1,1), $lowercase, $uppercase), $indexChar)">
				<DD>	
					<xsl:variable name="packagename" select="translate(../@NAME, $namesFromCase, $namesToCase)"/>
					<!-- create link referrer -->
					<xsl:variable name="referrer">
			      <xsl:value-of select="$packagename"/>
   					      <xsl:value-of select="'.html#'"/>
						<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)" />
               <xsl:if test="ARGUMENT">
                <xsl:text>(</xsl:text>
								<xsl:for-each select="ARGUMENT">
 									<xsl:value-of select="@TYPE"/>
 									<xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:text>)</xsl:text>
							</xsl:if>
					</xsl:variable>
									
			    <!-- create link -->
			    <xsl:element name="A">
	        <xsl:attribute name="HREF">
			        <xsl:value-of select="translate($referrer,$uppercase,$lowercase)"/>
			      </xsl:attribute>
			    	<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)"/>        
					</xsl:element>
					
					&nbsp; <FONT SIZE="-1">(<xsl:value-of select="$packagename"/>)</FONT>
					
					<BR/>
				  
				  <!-- xsl:value-of select="COMMENT_FIRST_LINE"/ -->
					<xsl:call-template name="processInlineTag">
						<xsl:with-param name="comment" select="COMMENT_FIRST_LINE" />
						<xsl:with-param name="tag" select="'link'" />
					</xsl:call-template>
				  
				  <P/>
				</DD>
				</xsl:if>

		</xsl:for-each>

			<xsl:for-each select="PACKAGE/child::*">
				<xsl:sort select="translate(@NAME, $namesFromCase, $namesToCase)"/>
				
				<xsl:if test="starts-with(translate(substring(@NAME, 1,1), $lowercase, $uppercase), $indexChar)">
				<DD>	
					<xsl:variable name="packagename" select="translate(../@NAME, $namesFromCase, $namesToCase)"/>
					<!-- create link referrer -->
					<xsl:variable name="referrer">
			      <xsl:value-of select="$packagename"/>
   					      <xsl:value-of select="'.html#'"/>
						<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)" />
               <xsl:if test="ARGUMENT">
                <xsl:text>(</xsl:text>
								<xsl:for-each select="ARGUMENT">
 									<xsl:value-of select="@TYPE"/>
 									<xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:text>)</xsl:text>
							</xsl:if>
					</xsl:variable>
									
			    <!-- create link -->
			    <xsl:element name="A">
	        <xsl:attribute name="HREF">
			        <xsl:value-of select="$referrer"/>
			      </xsl:attribute>
			    	<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)"/>        
					</xsl:element>
					
					&nbsp; <FONT SIZE="-1">(<xsl:value-of select="$packagename"/>)</FONT>
					
					<BR/>
				  
					<!-- xsl:value-of select="COMMENT_FIRST_LINE"/ -->
					<xsl:call-template name="processInlineTag">
						<xsl:with-param name="comment" select="COMMENT_FIRST_LINE" />
						<xsl:with-param name="tag" select="'link'" />
					</xsl:call-template>
					
				  <P/>
				</DD>
				</xsl:if>

		</xsl:for-each>

<!-- Include Bodies in the index Start -->
			<xsl:for-each select="OBJECT_BODY/child::*">
				<xsl:sort select="translate(@NAME, $namesFromCase, $namesToCase)"/>
				
				<xsl:if test="starts-with(translate(substring(@NAME, 1,1), $lowercase, $uppercase), $indexChar)">
				<DD>	
					<xsl:variable name="packagename" select="translate(../@NAME, $namesFromCase, $namesToCase)"/>
					<!-- create link referrer -->
					<xsl:variable name="referrer">
			      <xsl:value-of select="'_'"/>
			      <xsl:value-of select="$packagename"/>
   					      <xsl:value-of select="'_body.html#'"/>
						<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)" />
               <xsl:if test="ARGUMENT">
                <xsl:text>(</xsl:text>
								<xsl:for-each select="ARGUMENT">
 									<xsl:value-of select="@TYPE"/>
 									<xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:text>)</xsl:text>
							</xsl:if>
					</xsl:variable>
									
			    <!-- create link -->
			    <xsl:element name="A">
	        <xsl:attribute name="HREF">
			        <xsl:value-of select="$referrer"/>
			      </xsl:attribute>
			    	<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)"/>        
					</xsl:element>
					
					&nbsp; <FONT SIZE="-1">(<xsl:value-of select="$packagename"/> body)</FONT>
					
					<BR/>
				  
					<!-- xsl:value-of select="COMMENT_FIRST_LINE"/ -->
					<xsl:call-template name="processInlineTag">
						<xsl:with-param name="comment" select="COMMENT_FIRST_LINE" />
						<xsl:with-param name="tag" select="'link'" />
					</xsl:call-template>
					
				  <P/>
				</DD>
				</xsl:if>

		</xsl:for-each>

			<xsl:for-each select="PACKAGE_BODY/child::*">
				<xsl:sort select="translate(@NAME, $namesFromCase, $namesToCase)"/>
				
				<xsl:if test="starts-with(translate(substring(@NAME, 1,1), $lowercase, $uppercase), $indexChar)">
				<DD>	
					<xsl:variable name="packagename" select="translate(../@NAME, $namesFromCase, $namesToCase)"/>
					<!-- create link referrer -->
					<xsl:variable name="referrer">
   			      <xsl:value-of select="'_'"/>
			      <xsl:value-of select="$packagename"/>
   					      <xsl:value-of select="'_body.html#'"/>
						<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)" />
               <xsl:if test="ARGUMENT">
                <xsl:text>(</xsl:text>
								<xsl:for-each select="ARGUMENT">
 									<xsl:value-of select="@TYPE"/>
 									<xsl:if test="not(position()=last())"><xsl:text>,</xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:text>)</xsl:text>
							</xsl:if>
					</xsl:variable>
									
			    <!-- create link -->
			    <xsl:element name="A">
	        <xsl:attribute name="HREF">
			        <xsl:value-of select="$referrer"/>
			      </xsl:attribute>
			    	<xsl:value-of select="translate(@NAME, $namesFromCase, $namesToCase)"/>        
					</xsl:element>
					
					&nbsp; <FONT SIZE="-1">(<xsl:value-of select="$packagename"/> body)</FONT>
					
					<BR/>
				  
					<!-- xsl:value-of select="COMMENT_FIRST_LINE"/ -->
					<xsl:call-template name="processInlineTag">
						<xsl:with-param name="comment" select="COMMENT_FIRST_LINE" />
						<xsl:with-param name="tag" select="'link'" />
					</xsl:call-template>
					
				  <P/>
				</DD>
				</xsl:if>

		</xsl:for-each>
<!-- Include Bodies in the index End -->

<!-- Include Bodies in the index End -->

		</DL>

	</xsl:template>

  <!-- ************************* START OF PAGE ***************************** -->
  <xsl:template match="/APPLICATION">
    <HTML>
    <HEAD>
    <TITLE><xsl:value-of select="@NAME" />: Index-List</TITLE>
    <LINK REL ="stylesheet" TYPE="text/css" HREF="stylesheet.css" TITLE="Style" />
    	<xsl:comment>
        sameCase=<xsl:value-of select="$samecase" />
        namesLowerCase=<xsl:value-of select="$namesLowerCase"  />
        namesUpperCase=<xsl:value-of select="$namesUpperCase"  />
        namesDefaultCase=<xsl:value-of select="$namesDefaultCase"  />
        defaultNamesCase=<xsl:value-of select="$defaultNamesCase"  />
        namesFromCase=<xsl:value-of select="$namesFromCase" />
        namesToCase=<xsl:value-of select="$namesToCase" />
      </xsl:comment>
    </HEAD>

    <BODY BGCOLOR="white">
    <!-- **************************** HEADER ******************************* -->
    <xsl:call-template name="NavigationBar"/>

    <CENTER><H2>Index</H2></CENTER>
    <P/><P/>

		<!-- Index links -->
		<A HREF="#A">A</A> &nbsp;
		<A HREF="#B">B</A> &nbsp;
		<A HREF="#C">C</A> &nbsp;
		<A HREF="#D">D</A> &nbsp;
		<A HREF="#E">E</A> &nbsp;
		<A HREF="#F">F</A> &nbsp;
		<A HREF="#G">G</A> &nbsp;
		<A HREF="#H">H</A> &nbsp;
		<A HREF="#I">I</A> &nbsp;
		<A HREF="#J">J</A> &nbsp;
		<A HREF="#K">K</A> &nbsp;
		<A HREF="#L">L</A> &nbsp;
		<A HREF="#M">M</A> &nbsp;
		<A HREF="#N">N</A> &nbsp;
		<A HREF="#O">O</A> &nbsp;
		<A HREF="#P">P</A> &nbsp;
		<A HREF="#Q">Q</A> &nbsp;
		<A HREF="#R">R</A> &nbsp;
		<A HREF="#S">S</A> &nbsp;
		<A HREF="#T">T</A> &nbsp;
		<A HREF="#U">U</A> &nbsp;
		<A HREF="#V">V</A> &nbsp;
		<A HREF="#W">W</A> &nbsp;
		<A HREF="#X">X</A> &nbsp;
		<A HREF="#Y">Y</A> &nbsp;
		<A HREF="#Z">Z</A> &nbsp;

		<!-- for each group construct is not standard XSLT -->
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">A</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">B</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">C</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">D</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">E</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">F</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">G</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">H</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">I</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">J</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">K</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">L</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">M</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">N</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">O</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">P</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">Q</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">R</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">S</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">T</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">U</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">V</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">X</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">Y</xsl:with-param></xsl:call-template>
    <xsl:call-template name="IndexGroup"><xsl:with-param name="indexChar">Z</xsl:with-param></xsl:call-template>



    
	
    <!-- ***************************** FOOTER ****************************** -->
    <xsl:call-template name="NavigationBar"/>

    </BODY>
    </HTML>
  </xsl:template>

</xsl:stylesheet>
