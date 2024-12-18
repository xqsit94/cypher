document.addEventListener("DOMContentLoaded", function () {
	let currentMode = "encode";

	// Tab switching
	document.querySelectorAll(".tab").forEach((tab) => {
		tab.addEventListener("click", function () {
			document
				.querySelectorAll(".tab")
				.forEach((t) => t.classList.remove("active"));
			this.classList.add("active");
			currentMode = this.dataset.mode;

			const input = document.getElementById("inputText");
			const output = document.getElementById("outputText");

			input.value = "";
			output.value = "";

			input.placeholder = `Enter text to ${currentMode}...`;
			output.placeholder = `${currentMode}d text will appear here...`;
		});
	});

	// Process input changes
	async function processInput() {
		const text = document.getElementById("inputText").value.trim();
		const secret = document.getElementById("secretKey").value.trim();
		const salt = document.getElementById("saltKey").value.trim();
		const output = document.getElementById("outputText");

		if (!text || !secret || !salt) {
			output.value = "";
			return;
		}

		const endpoint = currentMode === "encode" ? "/encrypt" : "/decrypt";

		try {
			const response = await fetch(endpoint, {
				method: "POST",
				headers: {
					"Content-Type": "application/x-www-form-urlencoded",
				},
				body: `text=${encodeURIComponent(text)}&secret=${encodeURIComponent(secret)}&salt=${encodeURIComponent(salt)}`,
			});

			const data = await response.json();

			if (data.success) {
				output.value = data.result;
			} else {
				output.value = `Error: ${data.error}`;
			}
		} catch (error) {
			output.value = `Error: ${error.message}`;
		}
	}

	// Add event listeners for all inputs
	["inputText", "secretKey", "saltKey"].forEach((id) => {
		document.getElementById(id).addEventListener("input", processInput);
	});
});
