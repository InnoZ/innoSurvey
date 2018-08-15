import React from 'react';
import jsQR from "jsqr";

export default class ExhibitionScreen extends React.Component {
  constructor(props) {
    super(props);
    this.tick = this.tick.bind(this);
  }

  resetCamera() {
    if (animationFrame) { // if webcam available and delivering data
      video.pause();
      video.src = '';
      video.load();
      cancelAnimationFrame(animationFrame);
      video.srcObject.getTracks()[0].stop();
    }
  }

  componentWillUnmount() {
    this.resetCamera();
    clearInterval(this.cameraResetInterval);
  }

  componentWillUpdate() {
    this.resetCamera();
    this.initCamera();
  }

  componentDidMount() {
    const that = this;
    that.initCamera();
    this.cameraResetInterval = setInterval(function() {
      // reset camera each 20 seconds to overcome crashes
      // or reset view (on exhibition)
      if (that.props.reset) {
        that.props.reset();
      } else {
        that.resetCamera();
        that.initCamera();
      }
    }, 10000)

    // this.identWith(657656567, 1, '3BFB307CCD475D5A52ECC454474459F96403B31027B98E998091E3C4751DED70')
  }

  identWith(uuid, roleId, token) {
    console.log('uuid: ' + uuid)
    console.log('role id: ' + roleId)
    console.log('token: ' + token)
    // this refers to the ident method from either exhibition_screen or mobiel_screen component:
    this.props.ident(uuid, roleId, token);
  }

  initCamera() {
    // this together with tick() are based on
    // the jsQR demo example (https://cozmo.github.io/jsQR)
    window.animationFrame = null;
    if (navigator.mediaDevices) {
      const that = this;
      window.video = document.createElement("video");
      window.canvasElement = document.getElementById("canvas");
      window.canvas = canvasElement.getContext("2d");
      navigator.mediaDevices.getUserMedia({
        audio: false,
        video: {
          facingMode: "user",
          width: { max: 650 },
          height: { max: 600 }
        }
      }).then(function(stream) {
        video.srcObject = stream;
        video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
        video.play();
        window.animationFrame = requestAnimationFrame(that.tick);
      });
    }
  }

  drawLine(begin, end, color) {
    canvas.beginPath();
    canvas.moveTo(begin.x, begin.y);
    canvas.lineTo(end.x, end.y);
    canvas.lineWidth = 2;
    canvas.strokeStyle = color;
    canvas.stroke();
  }

  tick() {
    const that = this;
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
      canvasElement.height = video.videoHeight;
      canvasElement.width = video.videoWidth;
      canvas.translate(canvasElement.width, 0);
      canvas.scale(-1, 1);
      canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);
      // draw square in the middel of the canvas
      that.drawLine(
        {x: video.videoWidth * 1/4, y: video.videoHeight * 1/4},
        {x: video.videoWidth * 3/4, y: video.videoHeight * 1/4},
        "red"
      );
      that.drawLine(
        {x: video.videoWidth * 1/4, y: video.videoHeight * 3/4},
        {x: video.videoWidth * 1/4, y: video.videoHeight * 1/4},
        "red"
      );
      that.drawLine(
        {x: video.videoWidth * 1/4, y: video.videoHeight * 3/4},
        {x: video.videoWidth * 3/4, y: video.videoHeight * 3/4},
        "red"
      );
      that.drawLine(
        {x: video.videoWidth * 3/4, y: video.videoHeight * 1/4},
        {x: video.videoWidth * 3/4, y: video.videoHeight * 3/4},
        "red"
      );

      var imageData = canvas.getImageData(0, 0, canvasElement.width, canvasElement.height);
      var code = jsQR(imageData.data, imageData.width, imageData.height);
      if (code) {
        // try to new read url params
        let uuid = getUrlParam(code.data, 'uuid');
        let roleId = getUrlParam(code.data, 'role_id');
        let token = getUrlParam(code.data, 'token');
        let json;
        // try to read old json string
        if (json = this.stringFromJson(code.data)) {
          uuid = json.uuid;
          roleId = json.role_id;
          token = '3BFB307CCD475D5A52ECC454474459F96403B31027B98E998091E3C4751DED70';
        }
        if (uuid && roleId && token) { that.identWith(uuid, roleId, token); }
      }
    }
    window.animationFrame = requestAnimationFrame(that.tick);
  }

  stringFromJson(string) {
    try { return JSON.parse(string); } catch (e) { return false; }
  }

  fakeQrScan(event) {
    const uuid = document.getElementById('uuid-test-input').value;
    const roleId = document.getElementById('role-id-test-input').value;
    const token = document.getElementById('token-test-input').value;
    this.identWith(uuid, roleId, token)
  }

  render() {
    return (
      <div>
        <div className='question'>
          Scanne deinen QR-Code
          <div className='subtitle'>Du hast keinen? Besorge dir einen am Eingang</div>
        </div>
        <canvas id="canvas"></canvas>

        <div className='qr-code-test-replacement-input'>
          <input id='uuid-test-input' placeholder='uuid'></input>
          <input id='role-id-test-input' placeholder='role id'></input>
          <input id='token-test-input' placeholder='token'></input>
          <button id='send-fake-qr' onClick={this.fakeQrScan.bind(this)}>submit</button>
        </div>
      </div>
    );
  }


}
