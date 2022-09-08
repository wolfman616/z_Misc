window.addEventListener("keydown", function (event) {
	if (event.defaultPrevented) 
		return; // Quit if event already processed
	switch (event.key) {
		case "F1":
			if (event.getModifierState("Control"))
				window.scrollByPages(-99);
			else
				window.scrollByPages(-1);
			break;
		case "F2": 
			if (event.getModifierState("Control"))
				window.scrollByPages(99);
			else
				window.scrollByPages(1);
			break;
		default:
			return; // Quit when NOT handling the event.
	}
	event.preventDefault();  // Prevent default action to avoid it being handled twice
}, true);


