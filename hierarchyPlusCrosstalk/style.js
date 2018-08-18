vizmap = [

   {selector: "node", css: {
      "shape": "ellipse",
      "text-valign":"center",
       "text-halign":"center",
       "background-color":"white",
      "content": "data(name)",
      "border-color":"black","border-width":"1px",
      "width": "mapData(count, 0.0, 110.0, 30.0, 100.0)",
      "height":"mapData(count, 0.0, 120.0, 30.0, 100.0)",
      "font-size":"8px"}},

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

    {selector: "edge[type='interaction']", css: {
      "line-color": "rgb(200, 200, 200)",
      "target-arrow-shape": "triangle",
      "target-arrow-color": "red",
      "width": "mapData(count, 1, 20, 1, 20)",
      'curve-style': 'bezier'
      }},


   ];
