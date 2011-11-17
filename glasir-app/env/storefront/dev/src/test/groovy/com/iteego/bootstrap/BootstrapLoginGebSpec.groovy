import spock.lang.*
import geb.*
import geb.spock.*

class BootstrapLoginGebSpec extends GebReportingSpec {
	def "logging in with a non existent user results in an error"() {
		when:
		to BootstrapHomePage
		
		and:
		username.value "bogus user"
		
		and: 
    password.value "bogus password"
    
    and: 
    loginButton.click()
    
		then:
		at BootstrapHomePage

		and:
		formErrors.contains("The supplied login was invalid.")
	}
	
}