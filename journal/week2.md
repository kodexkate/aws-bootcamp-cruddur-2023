# Week 2 — Distributed Tracing

## X-Ray

### Instrument AWS X-Ray for Flask


```sh
export AWS_REGION="ca-central-1"
gp env AWS_REGION="ca-central-1"
```

I was able to add to the `requirements.txt`

```py
aws-xray-sdk
```
![Image 3-29-23 at 4 56 PM](https://user-images.githubusercontent.com/122316410/228694053-01ff7729-b763-4148-a9b5-bf5e29adc825.jpg)

Then I installed pythonpendencies

```sh
pip install -r requirements.txt
```

Then added this code to `app.py`

```py
from aws_xray_sdk.core import xray_recorder
from aws_xray_sdk.ext.flask.middleware import XRayMiddleware

xray_url = os.getenv("AWS_XRAY_URL")
xray_recorder.configure(service='Cruddur', dynamic_naming=xray_url)
XRayMiddleware(app, xray_recorder)
```
![Image 3-29-23 at 5 06 PM](https://user-images.githubusercontent.com/122316410/228695135-834d6e70-1eb0-4f46-9981-a2404959ce2a.jpg)

### Setup AWS X-Ray Resources

I then set up x-ray resources by creating an x-ray json file, then adding this code  `aws/json/xray.json`

```json
{
  "SamplingRule": {
      "RuleName": "Cruddur",
      "ResourceARN": "*",
      "Priority": 9000,
      "FixedRate": 0.1,
      "ReservoirSize": 5,
      "ServiceName": "Cruddur",
      "ServiceType": "*",
      "Host": "*",
      "HTTPMethod": "*",
      "URLPath": "*",
      "Version": 1
  }
}
```
![Image 3-29-23 at 5 13 PM](https://user-images.githubusercontent.com/122316410/228695855-7c0a0861-e7dd-43a4-a142-8aac6f6d783c.jpg)

```sh
FLASK_ADDRESS="https://4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}"
aws xray create-group \
   --group-name "Cruddur" \
   --filter-expression "service(\"$FLASK_ADDRESS\") {fault OR error}"
```

```sh
aws xray create-sampling-rule --cli-input-json file://aws/json/xray.json
```

 [Install X-ray Daemon](https://docs.aws.amazon.com/xray/latest/devguide/xray-daemon.html)

[Github aws-xray-daemon](https://github.com/aws/aws-xray-daemon)
[X-Ray Docker Compose example](https://github.com/marjamis/xray/blob/master/docker-compose.yml)


```sh
 wget https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-3.x.deb
 sudo dpkg -i **.deb
 ```

### Add Deamon Service to Docker Compose

```yml
  xray-daemon:
    image: "amazon/aws-xray-daemon"
    environment:
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
      AWS_REGION: "us-east-1"
    command:
      - "xray -o -b xray-daemon:2000"
    ports:
      - 2000:2000/udp
```

We need to add these two env vars to our backend-flask in our `docker-compose.yml` file

```yml
      AWS_XRAY_URL: "*4567-${GITPOD_WORKSPACE_ID}.${GITPOD_WORKSPACE_CLUSTER_HOST}*"
      AWS_XRAY_DAEMON_ADDRESS: "xray-daemon:2000"
```

### Check service data for last 10 minutes

```sh
EPOCH=$(date +%s)
aws xray get-service-graph --start-time $(($EPOCH-600)) --end-time $EPOCH
```

## HoneyComb

When creating a new dataset in Honeycomb it will provide all these installation insturctions



I was able to add the following files to my `requirements.txt`


![Image 3-22-23 at 1 50 PM](https://user-images.githubusercontent.com/122316410/227035085-1dc61e65-f5bb-487f-a1b8-2e0121f30ee7.jpg)



I successfully installed these dependencies:

```sh
pip install -r requirements.txt
```

Then added to the `app.py`


![Image 3-22-23 at 1 55 PM](https://user-images.githubusercontent.com/122316410/227036057-3a6fac72-ea55-4e69-8ee2-39a910f4e0eb.jpg)


```py
# Initialize tracing and an exporter that can send data to Honeycomb
provider = TracerProvider()
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
tracer = trace.get_tracer(__name__)
```
![Image 3-22-23 at 1 58 PM](https://user-images.githubusercontent.com/122316410/227036552-8c52ed8e-69e5-4179-b5e8-52ea3d327abd.jpg)

```py
# Initialize automatic instrumentation with Flask
app = Flask(__name__)
FlaskInstrumentor().instrument_app(app)
RequestsInstrumentor().instrument()
```
![Image 3-22-23 at 2 00 PM](https://user-images.githubusercontent.com/122316410/227036974-d48998e0-4000-45aa-b67d-11b6f12c9788.jpg)

I was able to add the following Env Vars to `backend-flask` in docker compose

```yml
OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io"
OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}"
OTEL_SERVICE_NAME: "${HONEYCOMB_SERVICE_NAME}"
```
![Image 3-22-23 at 2 02 PM](https://user-images.githubusercontent.com/122316410/227037441-8c54f0c2-b6c3-4122-a395-bc0b2636905d.jpg)


You'll need to grab the API key from your honeycomb account:
I was able to add these variables:

```sh
export HONEYCOMB_API_KEY=""
export HONEYCOMB_SERVICE_NAME="Cruddur"
gp env HONEYCOMB_API_KEY=""
gp env HONEYCOMB_SERVICE_NAME="Cruddur"
```
![Image 3-22-23 at 2 07 PM](https://user-images.githubusercontent.com/122316410/227038437-62878d42-b817-4df7-ae14-40ae3c1c03f9.jpg)


## CloudWatch Logs


Add to the `requirements.txt`

```
watchtower
```
![Image 3-30-23 at 5 07 PM](https://user-images.githubusercontent.com/122316410/228991152-784e2f41-b309-420c-b351-ff0aae2110fc.jpg)

```sh
pip install -r requirements.txt
```


In `app.py`

```
import watchtower
import logging
from time import strftime
```
![Image 3-30-23 at 5 12 PM](https://user-images.githubusercontent.com/122316410/228991584-9af639c6-90dd-4340-be15-2fc0eae5186a.jpg)

```py
# Configuring Logger to Use CloudWatch
LOGGER = logging.getLogger(__name__)
LOGGER.setLevel(logging.DEBUG)
console_handler = logging.StreamHandler()
cw_handler = watchtower.CloudWatchLogHandler(log_group='cruddur')
LOGGER.addHandler(console_handler)
LOGGER.addHandler(cw_handler)
LOGGER.info("some message")
```
![Image 3-30-23 at 5 10 PM](https://user-images.githubusercontent.com/122316410/228991602-5b9d5f69-452a-4565-9698-47a76abb12fb.jpg)

```py
@app.after_request
def after_request(response):
    timestamp = strftime('[%Y-%b-%d %H:%M]')
    LOGGER.error('%s %s %s %s %s %s', timestamp, request.remote_addr, request.method, request.scheme, request.full_path, response.status)
    return response
```
![Image 3-30-23 at 5 24 PM](https://user-images.githubusercontent.com/122316410/228992826-74612d66-c14f-416d-8249-858db965b7b0.jpg)

We'll log something in an API endpoint
```py
LOGGER.info('Hello Cloudwatch! from  /api/activities/home')
```

Set the env var in your backend-flask for `docker-compose.yml`

```yml
      AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION}"
      AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
      AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
```

![Image 3-30-23 at 5 25 PM](https://user-images.githubusercontent.com/122316410/228993661-208dd007-1835-4955-b4df-a169accd9e9f.jpg)



## Rollbar

https://rollbar.com/

Create a new project in Rollbar called `Cruddur`

Add to `requirements.txt`


```
blinker
rollbar
```
![Image 3-30-23 at 7 20 PM](https://user-images.githubusercontent.com/122316410/229007567-7c499d7a-20eb-4ae2-8a29-78321b70b427.jpg)

Install deps

```sh
pip install -r requirements.txt
```

We need to set our access token

```sh
export ROLLBAR_ACCESS_TOKEN=""
gp env ROLLBAR_ACCESS_TOKEN=""
```
![Image 3-30-23 at 7 34 PM](https://user-images.githubusercontent.com/122316410/229008514-083f93d8-ed61-4a62-8c49-78f7c73e4e71.jpg)

Add to backend-flask for `docker-compose.yml`

```yml
ROLLBAR_ACCESS_TOKEN: "${ROLLBAR_ACCESS_TOKEN}"
```
![Image 3-30-23 at 7 39 PM](https://user-images.githubusercontent.com/122316410/229009217-d4f75677-7260-4638-a964-660a27d119bb.jpg)

Import for Rollbar

```py
import rollbar
import rollbar.contrib.flask
from flask import got_request_exception
```
![Image 3-30-23 at 8 06 PM](https://user-images.githubusercontent.com/122316410/229012804-b642d6f5-8a53-4b49-8a31-190e46221130.jpg)

```py
rollbar_access_token = os.getenv('ROLLBAR_ACCESS_TOKEN')
@app.before_first_request
def init_rollbar():
    """init rollbar module"""
    rollbar.init(
        # access token
        rollbar_access_token,
        # environment name
        'production',
        # server root directory, makes tracebacks prettier
        root=os.path.dirname(os.path.realpath(__file__)),
        # flask already sets up logging
        allow_logging_basic_config=False)

    # send exceptions from `app` to rollbar, using flask's signal system.
    got_request_exception.connect(rollbar.contrib.flask.report_exception, app)
```
![Image 3-30-23 at 8 07 PM](https://user-images.githubusercontent.com/122316410/229012898-7d8617df-df93-4e0d-9fd4-35a277c705e3.jpg)

We'll add an endpoint just for testing rollbar to `app.py`

```py
@app.route('/rollbar/test')
def rollbar_test():
    rollbar.report_message('Hello World!', 'warning')
    return "Hello World!"
```
![Image 3-30-23 at 8 08 PM](https://user-images.githubusercontent.com/122316410/229013005-e2265d64-a9a9-418e-a0cb-5e9115a4a7a4.jpg)


[Rollbar Flask Example](https://github.com/rollbar/rollbar-flask-example/blob/master/hello.py)
