"use strict";

/*
 ___       _ _   _       _ _          _   _
|_ _|_ __ (_) |_(_) __ _| (_)______ _| |_(_) ___  _ __
 | || '_ \| | __| |/ _` | | |_  / _` | __| |/ _ \| '_ \
 | || | | | | |_| | (_| | | |/ / (_| | |_| | (_) | | | |
|___|_| |_|_|\__|_|\__,_|_|_/___\__,_|\__|_|\___/|_| |_|

*/
$(document).ready(function () {
	// wire up color scheme
	$("body, #outer")
		.addClass("background-normal")
		.addClass("foreground-normal")
		.addClass("border-normal");
})

/*
__     __    _     _   __  __       _          __                    __
\ \   / /__ (_) __| | |  \/  | __ _(_)_ __    / /__ _ _ __ __ ___   _\ \
 \ \ / / _ \| |/ _` | | |\/| |/ _` | | '_ \  | |/ _` | '__/ _` \ \ / /| |
  \ V / (_) | | (_| | | |  | | (_| | | | | | | | (_| | | | (_| |\ V / | |
   \_/ \___/|_|\__,_| |_|  |_|\__,_|_|_| |_| | |\__,_|_|  \__, | \_/  | |
                                              \_\         |___/      /_/
*/
$(window).on("load", function () {
	window.onerror = function (message, source, lineno, colno, error) {
		$("#outter").append(
			"<p class=\"error-message\">" +
				source + " at line " + lineno + ": " + message +
			"</p>"
		);
	}

	// if (typeof(Worker)) {
	// 	var Wolfenstein = new Worker("js/wolfenstein.js");
	// } else {
	// 	throw new Error("Web Workers are not supported.");
	// }

	var canvas = new Drawing.Canvas("#canvas", 8);

	var makeFullScreen = function () {
		$("#outter")
			.width($(window).width())
			.height($(window).height());
	};

	var updateCompass = function () {
		if (!$("body").data("show-map")) {
			return;
		}

		canvas.beginPath();

		// point in front of viewPoint
		var tmp = canvas.space.viewPoint.getRotation();
		canvas.space.viewPoint.setRotation(tmp + 180);
		var theta = Raytracing.Math.degreesToRadians(canvas.space.viewPoint.getRotation());
		canvas.space.viewPoint.setRotation(tmp);
		var x = canvas.getWidth()  - (canvas.space.viewPoint.getXPos() * canvas.getScale() + canvas.getScale() / 2) + (Math.sin(theta) * canvas.getScale() * 2);
		var y = canvas.getHeight() - (canvas.space.viewPoint.getYPos() * canvas.getScale() + canvas.getScale() / 2) + (Math.cos(theta) * canvas.getScale() * 2);
		canvas._context.moveTo((x + (Math.sin(theta) * canvas.getScale())),
		                       (y + (Math.cos(theta) * canvas.getScale())));

		// point to left of viewPoint
		var tmp = canvas.space.viewPoint.getRotation();
		canvas.space.viewPoint.setRotation(tmp + 90);
		var theta = Raytracing.Math.degreesToRadians(canvas.space.viewPoint.getRotation());
		canvas.space.viewPoint.setRotation(tmp);
		canvas._context.lineTo((x + (Math.sin(theta) * canvas.getScale())),
		                       (y + (Math.cos(theta) * canvas.getScale())));

		// point to right of viewPoint
		var tmp = canvas.space.viewPoint.getRotation();
		canvas.space.viewPoint.setRotation(tmp - 90);
		var theta = Raytracing.Math.degreesToRadians(canvas.space.viewPoint.getRotation());
		canvas.space.viewPoint.setRotation(tmp);
		canvas._context.lineTo((x + (Math.sin(theta) * canvas.getScale())),
		                       (y + (Math.cos(theta) * canvas.getScale())));

		canvas.fillStyle("rgb(255, 255, 255)");
		canvas.fill();
	}

	var randomPixel = function () {
		return new Drawing.Pixel(Math.round(Math.random() * 255),
		                         Math.round(Math.random() * 255),
		                         Math.round(Math.random() * 255));
	}

	// make the outer wrapper fullscreen and responsive
	makeFullScreen();
	$(window).on("resize", makeFullScreen);

	// draw some rectangles
	canvas.space.drawRectangle(5, 25, 9, 72, Drawing.Colors.Grey);
	canvas.space.drawRectangle(15, 75, 19, 92, Drawing.Colors.Grey);
	canvas.space.drawRectangle(25, 15, 29, 48, Drawing.Colors.Grey);
	canvas.space.drawRectangle(95, 75, 56, 93, Drawing.Colors.Grey);

	// draw a room
	canvas.space.drawRectangle(95, 5, 36, 43, Drawing.Colors.Grey);
	canvas.space.drawRectangle(80, 42, 60, 43, new Drawing.Pixel());

	// draw a room with a hidden door
	canvas.space.drawRectangle(100, 150, 600, 700, Drawing.Colors.Blue);
	canvas.space.drawRectangle(110, 160, 130, 161, Drawing.Colors.Blue);
	canvas.space.drawRectangle(110, 150, 130, 151, new Drawing.Pixel());

	// draw some circles
	canvas.space.drawCircle(30, 70, 10, Drawing.Colors.Green);

	// draw the space border (last)
	for (var x = 0; x < canvas.space.getWidth(); x++) {
		for (var y = 0; y < canvas.space.getLength(); y++) {
			if (y <= 1                            ||
			    x <= 1                            ||
			    y >= canvas.space.getLength() - 2 ||
			    x >= canvas.space.getWidth() - 2
			) {
				canvas.space.drawPoint(x, y, Drawing.Colors.White);
			}
		}
	}

	setInterval(function () {
		if ($("body").data("show-map")) {
			canvas.drawFrame(canvas.map());
		} else {
			canvas.drawFrame(canvas.render());
		}

		updateCompass();
	}, 1000 / Drawing.Canvas.FramesPerSecond);

	// wire up some mouse controls
	$("input[name=toggle-map]").on("click", function (event) {
		$("body").data("show-map", !$("body").data("show-map"));
	});

	$("input[name=field-of-view]").val(Raytracing.ViewPoint.FieldOfView);
	$("input[name=field-of-view]").on("change", function (event) {
		Raytracing.ViewPoint.FieldOfView = $(this).val();
	});

	$("input[name=vanishing-distance]").val(Raytracing.ViewPoint.VanishingDistance);
	$("input[name=vanishing-distance]").on("change", function (event) {
		Raytracing.ViewPoint.VanishingDistance = $(this).val();
	});

	$("input[name=default-rotation-delta]").val(Raytracing.ViewPoint.DefaultRotationDelta);
	$("input[name=default-rotation-delta]").on("change", function (event) {
		Raytracing.ViewPoint.DefaultRotationDelta = $(this).val();
	});

	$("input[name=default-movement-distance]").val(Raytracing.ViewPoint.DefaultMovementDistance);
	$("input[name=default-movement-distance]").on("change", function (event) {
		Raytracing.ViewPoint.DefaultMovementDistance = $(this).val();
	});

	// wire up some keyboard controls
	$(window).on("keydown", function (event) {
		var key = event.key.toLowerCase();
		var alt = event.altKey;
		var shf = event.shiftKey;
		var ctl = event.ctrlKey;

		switch (key) {
			case "arrowup":
				canvas.space.viewPoint.moveForwards(1); // tiptoe
				break;
			case "arrowleft":
				canvas.space.viewPoint.turnLeft(1); // turn
				break;
			case "arrowdown":
				canvas.space.viewPoint.moveBackwards(1); // tiptoe
				break;
			case "arrowright":
				canvas.space.viewPoint.turnRight(1); // turn
				break;
			case "w":
				canvas.space.viewPoint.moveForwards(5); // running
				break;
			case "a":
				canvas.space.viewPoint.moveLeft(2.5); // running
				break;
			case "s":
				canvas.space.viewPoint.moveBackwards(5); // running
				break;
			case "d":
				canvas.space.viewPoint.moveRight(2.5); // running
				break;
		}
	});
});
