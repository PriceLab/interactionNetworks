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
      "font-size":"8px"}},

    {selector: "node[type='informationalNode']", css: {
        "shape": "roundrectangle",
        "width": "120px",
        "height": "40px",
        "font-size": "24px",
        "content": "data(week)",
        }},

    {selector:"node[employmentCategory='intern']", css: {
        "shape": "roundrectangle"
        }},

    {selector:"node[active=1]", css: {
        "display": "element"
        }},

    {selector:"node[active=0]", css: {
        "display": "none"
        }},

   /************/
   {selector:"node:selected", css: {
       "text-valign":"center",
       "text-halign":"center",
       "border-color": "black",
       "content": "data(id)",
       "border-width": "3px",
       "overlay-opacity": 0.5,
       "overlay-color": "purple",
       "font-size": "18px"
       }},
    /*************/

   {selector: 'edge', css: {
      "line-color": "rgb(200, 200, 200)",
      "target-arrow-shape": "triangle",
      "target-arrow-color": "rgb(0, 0, 0)",
       "width": "mapData(count, 1, 20, 1, 20)",
      'curve-style': 'bezier'
      }},


   ];
