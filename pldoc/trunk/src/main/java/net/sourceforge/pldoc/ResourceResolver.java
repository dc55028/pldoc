/* Copyright (C) 2002 Albert Tumanov

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

*/

package net.sourceforge.pldoc;

import javax.xml.transform.URIResolver;
import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;
import java.io.FileInputStream;
import java.io.File;
import java.net.URI;
import java.net.URL;

public class ResourceResolver implements URIResolver
{
  public Source resolve(String href, String base) 
                              throws TransformerException
  {
    if(null==href || href.length() == 0 )
      return null; // will make Oracle XSLT processor explode, 
                   // even though it's correct 
    try    {
      //System.err.println("ResourceResolver.resolve: href=\""+href+"\", base=\""+base+"\"");
      String resource = href; 
      File file = new File (resource);
      //System.err.println("ResourceResolver.resolve: file=\""+file+"\"" );
      URI uri = new URI (resource);
      //System.err.println("ResourceResolver.resolve: URI=\""+uri+"\"" );
      //URL url = new URL (resource);
      //System.err.println("ResourceResolver.resolve: URL=\""+url+"\"" );
      if (file.exists())
      {
        return new StreamSource(new FileInputStream(file), resource);
      }
      else 
      {
        return new StreamSource(uri.toURL().openStream(), resource);
      }
    } // try
    catch(Exception ex)
    { //Fallback to reading resource
      try    {
        //System.err.println("ResourceResolver.resolve: Fallback href=\""+href+"\", base=\""+base+"\"");
        String resource = href; 
        ResourceLoader loader = new ResourceLoader();
        return new StreamSource(loader.getResourceStream(resource), resource);
      } // try
      catch(Exception rex)
      {
        throw new TransformerException(ex);
      } // catch
    } // catch
  } // resolve
} // ResourceResolver

