/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import liquibase.resource.CompositeResourceAccessor
import liquibase.resource.ResourceAccessor

/**
 * Created by IntelliJ IDEA.
 * User: martin
 * Date: 2011-06-14
 * Time: 16:42
 * To change this template use File | Settings | File Templates.
 */
class BetterCompositeResourceAccessor extends CompositeResourceAccessor {
  List<ResourceAccessor> overriddenOpeners

  public BetterCompositeResourceAccessor( List<ResourceAccessor> accessorList ) {
    super( accessorList )
    this.overriddenOpeners = new ArrayList<ResourceAccessor>( accessorList )
  }

  public List<ResourceAccessor> getAccessors() {
    return overriddenOpeners
  }

  public CustomFileSystemResourceAccessor getCustomAccessor() {
    ResourceAccessor result = overriddenOpeners.find {
      it instanceof CustomFileSystemResourceAccessor
    }
    if( result != null ) {
      return result as CustomFileSystemResourceAccessor
    }
    return null
  }
}
