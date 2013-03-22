package com.sample;

import org.junit.Test;
import org.junit.Assert;

public class SampleComponentImplementationTest {
  @Test
  public void testIsOdd() {
    SampleComponentImplementation m = new SampleComponentImplementation();
    Assert.assertFalse( "Error in isEven method for value 1.", m.isEven( 1 ) );
    Assert.assertTrue( "Error in isEven method for value 2.", m.isEven( 2 ) );
  }
}
