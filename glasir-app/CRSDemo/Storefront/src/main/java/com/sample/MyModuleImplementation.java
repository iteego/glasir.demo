package com.sample;

import atg.nucleus.GenericService;

public class MyModuleImplementation extends GenericService {

	private String _someValue;


	public MyModuleImplementation() {
		System.out.println( "A MyModuleImplementation has been created. SomeValue = " + getSomeValue() );
	}


	public boolean isEven( long value ) { return (value % 2 == 0); }


	public String getSomeValue() { return _someValue; }

	public void setSomeValue( String newValue ) { _someValue = newValue; }
}
