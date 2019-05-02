package org.dvcama.lodview.controllers;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dvcama.lodview.bean.HomeImageBean;
import org.dvcama.lodview.bean.OntologyBean;
import org.dvcama.lodview.conf.ConfigurationBean;
import org.dvcama.lodview.endpoint.SPARQLEndPoint;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UrlPathHelper;

@Controller
public class StaticController {
	@Autowired
	ConfigurationBean conf;

	@Autowired
	private MessageSource messageSource;

	@Autowired
	OntologyBean ontoBean;
	
	public StaticController() {
		// TODO Auto-generated constructor stub
	}

	public StaticController(MessageSource messageSource) {
		this.messageSource = messageSource;
	}

	@RequestMapping(value = "/")
	public String home(HttpServletRequest req, HttpServletResponse res, Model model, Locale locale, @CookieValue(value = "colorPair", defaultValue = "") String colorPair) {
		colorPair = conf.getRandomColorPair();
		Cookie c = new Cookie("colorPair", colorPair);
		c.setPath("/");
		res.addCookie(c);
		model.addAttribute("colorPair", colorPair);
		model.addAttribute("conf", conf);
		model.addAttribute("locale", locale.getLanguage());
		model.addAttribute("path", new UrlPathHelper().getContextPath(req).replaceAll("/lodview/", "/"));
		
		SPARQLEndPoint se = new SPARQLEndPoint(conf, ontoBean, locale.getLanguage());				
		try {
			model.addAttribute("images", groupBy(se.doHomeQuery()));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		System.out.println("home controller");
		return "home";
	}
	
	
	@RequestMapping(value = "/about")
	public String about(HttpServletRequest req, HttpServletResponse res, Model model, Locale locale, @CookieValue(value = "colorPair", defaultValue = "") String colorPair) {
		colorPair = conf.getRandomColorPair();
		Cookie c = new Cookie("colorPair", colorPair);
		c.setPath("/");
		res.addCookie(c);
		model.addAttribute("colorPair", colorPair);
		model.addAttribute("conf", conf);
		model.addAttribute("locale", locale.getLanguage());
		model.addAttribute("path", new UrlPathHelper().getContextPath(req).replaceAll("/lodview/", "/"));
		
		System.out.println("about controller");
		return "about";
	}

	private Map<String, List<HomeImageBean>> groupBy(List<HomeImageBean> beans) {
		
		Map<String, List<HomeImageBean>> moppy = new TreeMap<String, List<HomeImageBean>>();
		// extract thumbnails per resource
		
		
		// for each resource use only the first occurence
		
		
		// add the images to the resource
		
		
		// group by year
		String lastYear = beans.get(0).getYear();
		List<HomeImageBean> beany = new ArrayList<HomeImageBean>();
		for (HomeImageBean item : beans){
			if (!lastYear.equals(item.getYear())){
				moppy.put(lastYear, beany);
				beany = new ArrayList<HomeImageBean>();
			}
			beany.add(item);	
			lastYear=item.getYear();
		}
		
		return moppy;
	}

	@RequestMapping(value = "/lodviewmenu")
	public String lodviewmenu(Model model, HttpServletRequest req, HttpServletResponse res, Locale locale, @RequestParam(value = "IRI") String IRI, @CookieValue(value = "colorPair", defaultValue = "") String colorPair) {
		if (colorPair.equals("")) {
			colorPair = conf.getRandomColorPair();
			Cookie c = new Cookie("colorPair", colorPair);
			c.setPath("/");
			res.addCookie(c);
		}
		return lodviewmenu(req, res, model, locale, IRI, conf, colorPair);
	}

	@RequestMapping(value = { "/lodviewcolor", "/**/lodviewcolor" })
	public ResponseEntity<String> lodviewcolor(Model model, HttpServletRequest req, HttpServletResponse res, Locale locale, @RequestParam(value = "colorPair") String colorPair) {
		Cookie c = new Cookie("colorPair", colorPair);
		c.setPath("/");
		res.addCookie(c);
		return new ResponseEntity<String>(HttpStatus.OK);
	}

	public String lodviewmenu(HttpServletRequest req, HttpServletResponse res, Model model, Locale locale, @RequestParam(value = "IRI", defaultValue = "") String IRI, ConfigurationBean conf, String colorPair) {
		model.addAttribute("conf", conf);
		model.addAttribute("locale", locale.getLanguage());
		model.addAttribute("IRI", IRI);
		model.addAttribute("colorPair", colorPair);
		model.addAttribute("path", new UrlPathHelper().getContextPath(req).replaceAll("/lodview/", "/"));
		return "menu";
	}

}
