window.addEventListener("keydown", function (event) {
  if (event.defaultPrevented) {
    return; // Do nothing if the event was already processed
  }

  switch (event.key) {
	case "F1": // f1
		window.scrollByPages(-1);
		break;
	case "F2": // f2
		window.scrollByPages(1);
		break;
	default:
		return; // Quit when this doesn't handle the key event.
  }

  // Cancel the default action to avoid it being handled twice
  event.preventDefault();
}, true);
