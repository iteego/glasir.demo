package com.sample;

import atg.nucleus.GenericService;

public class SampleComponentImplementation extends GenericService {

  private String _someValue;


  public SampleComponentImplementation() {
    System.out.println( "SampleComponentImplementation instance created" );
  }


  public boolean isEven( long value ) { 
    return (value % 2 == 0); 
  }


  public String getSomeValue() { 
    return _someValue; 
  }

  public void setSomeValue( String newValue ) { 
    _someValue = newValue; 
  }
}
