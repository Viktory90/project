package com.olbius.widget.menu;

import org.w3c.dom.Element;

@SuppressWarnings("serial")
public class ModelMenu extends org.ofbiz.widget.menu.ModelMenu {
	protected String style;
	protected String iconStyle;
	protected String breakStyle;
	protected String id;
	
	
	public ModelMenu(Element menuElement) {
        super(menuElement);
        
        if (this.style == null || menuElement.hasAttribute("style"))
            this.style = menuElement.getAttribute("style");
        if (this.iconStyle == null || menuElement.hasAttribute("iconStyle"))
            this.iconStyle = menuElement.getAttribute("iconStyle");
        if (this.breakStyle == null || menuElement.hasAttribute("breakStyle"))
            this.breakStyle = menuElement.getAttribute("breakStyle");
        if (this.id == null || menuElement.hasAttribute("id"))
            this.id = menuElement.getAttribute("id");
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getStyle() {
		return style;
	}
	public void setStyle(String style) {
		this.style = style;
	}
	public String getIconStyle() {
		return iconStyle;
	}
	public void setIconStyle(String iconStyle) {
		this.iconStyle = iconStyle;
	}
	public String getBreakStyle() {
		return breakStyle;
	}
	public void setBreakStyle(String breakStyle) {
		this.breakStyle = breakStyle;
	}

}
