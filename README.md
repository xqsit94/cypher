# Cypher - Text Encoder/Decoder

A simple web application for encoding and decoding text using AES encryption with custom secret and salt keys.

## Quick Start with Docker

The easiest way to run this application is using Docker. The image is available on Docker Hub at [xqsit94/cypher](https://hub.docker.com/r/xqsit94/cypher).

### Basic Usage

```bash
docker run --rm --name cypher -p 8000:8000 xqsit94/cypher
```

This will start the application on port 8000. You can access it at http://localhost:8000

## Building from Source

If you want to build the Docker image yourself:

1. Clone the repository
2. Build the image:
```bash
docker build -t xqsit94/cypher .
```

3. Run the container:
```bash
docker run -p 8000:8000 xqsit94/cypher
```

## Usage

1. Open your browser and navigate to http://localhost:8000
2. Choose between Encoder or Decoder mode
3. Enter your secret key and salt key (if not provided via environment variables)
4. Enter the text you want to encode/decode
5. The result will appear automatically in the output field

## Features

- Real-time encoding/decoding
- AES encryption
- Custom secret and salt keys
- Docker support

## License

This project is open-source and available under the MIT License.

---
Made with ❤️ by xqsit94
