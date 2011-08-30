import org.junit.* ;
import static org.junit.Assert.* ;

public class MyTest {

    public MyTest() { }

    @Test
    public void testSomething() {
        assert 1 == 1;
        assert 2 + 2 == 4 : "We're in trouble, arithmetic is broken";
    }

}
