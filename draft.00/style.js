vizmap = [

   {selector: "node", css: {
      "shape": "ellipse",
      "text-valign":"center",
      "text-halign":"center",
      "content": "data(name)",
      "border-color":"black","border-width":"1px",
      "width": "mapData(count, 0.0, 110.0, 30.0, 100.0)",
      "height":"mapData(count, 0.0, 120.0, 30.0, 100.0)",
      //"background-color": "mapData(pearson, -1.0, 0, green, white)",
       "background-color":"mapData(count, 0, 120, white, red)",
       "font-size":"5px"}},

    //*********************INTERNS NODE *******************************
    {selector:"node[employmentCategory='intern']", css: {
        "shape": "roundrectangle",
	"text-valign":"center",
	"text-halign":"center",
	 "content": "data(name)",
      "border-color":"black","border-width":"0px",
      "width": "mapData(count, 0.0, 130.0, 40.0,130.0)",
      "height":"mapData(count, 0.0, 130.0, 40.0, 130.0)",
      //"background-color": "mapData(pearson, -1.0, 0, purple, white)",
      "background-color":"yellow",
	"font-size":"6px",
	"font-color": "white",
    }},

   {selector:"node:selected", css: {
       "text-valign":"centere",
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
      "width": "2px",
      'curve-style': 'bezier'
      }},


   ];

