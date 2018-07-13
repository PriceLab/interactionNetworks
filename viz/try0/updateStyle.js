vizmap = [
    
    {selector: "node", css: {
	"shape": "ellipse",
	"text-valign":"center",
	"text-halign":"center",
	//"content": "data(id)",
	"border-color":"black",
	"border-width":"1px",
	"width": "mapData(count, 0.0, 110.0, 30.0, 100.0)",
	"height":"mapData(count, 0.0, 120.0, 30.0, 100.0)",
	"color":"black",
	//"background-color": "mapData(pearson, -1.0, 0, green, blue)"
	"background-color":"mapData(newman, -1.0, 0.0, white, red)",
	"background-color":"mapData(newman, 0.0, 1.0, white, blue)",
	"font-size":"8px"}},
    
    {selector:"node[employmentCategory='intern']", css: {
        "shape": "roundrectangle"
    }},
    
    {selector: "node[newman < 0]", css: {
	"background-color": "mapData(newman, -1.0, 0.0, red, white)"
    }}, 

    {selector: "node[newman >= 0]", css: {
	"background-color": "mapData(newman, 0.0, 1.0. white, blue)"
    }}, 

    {selector:"node:selected", css: {
	"text-valign":"center",
	"text-halign":"center",
	"border-color": "black",
	"content": "data(id)",
	"border-width": "3px",
	"overlay-opacity": 0.5,
	"overlay-color": "purple"
    }},
    
    {selector: 'edge', css: {
	"line-color": "rgb(200, 200, 200)",
	"target-arrow-shape": "triangle",
	"target-arrow-color": "rgb(0, 0, 0)",
	"width": "mapData(count, 1, 20, 1, 20)",
	'curve-style': 'bezier'
    }},
    
    
];

