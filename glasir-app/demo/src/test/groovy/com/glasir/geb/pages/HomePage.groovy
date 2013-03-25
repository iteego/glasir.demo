package com.glasir.geb.pages

import geb.*

class HomePage extends Page {
	static url = "/crs/"
  static at = { $("body", class: "atg_store_pageHome") }

	static content = {
	  welcomeMessage { $("li", class: "atg_store_welcomeMessage").text().trim() }
	}
}
