'use strict';

const SPEAK_API = 'https://api.d-id.com/talks/streams';
const ICE_SERVERS = [{ urls: ['stun:stun.l.google.com:19302'] }];

const RTCPeerConnection = (
  window.RTCPeerConnection ||
  window.webkitRTCPeerConnection ||
  window.mozRTCPeerConnection
).bind(window);

let peerConnection;
let streamId;
let sessionId;
let sessionClientAnswer;
const talkVideo = document.getElementById('talk-video');

// Function to connect to the avatar service
async function connectAvatar() {
  if (peerConnection && peerConnection.connectionState === 'connected') {
    console.log('Already connected');
    return;
  }

  const videoElement = document.getElementById('talk-video');
  if (!videoElement) throw new Error('No video element found');

  try {
    const { offer, iceServers, streamId: sId } = await createStream();
    streamId = sId;

    if (peerConnection) {
      peerConnection.close();
    }
    peerConnection = new RTCPeerConnection({ iceServers: iceServers || ICE_SERVERS });

    peerConnection.ontrack = ({ track, streams }) => {
      console.log('Received track:', track);
      if (track.kind === 'video') {
        videoElement.srcObject = streams[0];
      }
    };

    peerConnection.onicecandidate = ({ candidate }) => {
      if (!candidate) return;
      console.log('Sending ICE candidate:', candidate);
      sendICECandidate(candidate);
    };

    peerConnection.oniceconnectionstatechange = () => {
      console.log('ICE Connection State:', peerConnection.iceConnectionState);
      if (window.flutter_inappwebview) {
        window.flutter_inappwebview.callHandler('Flutter', {
          type: 'connection',
          state: peerConnection.iceConnectionState
        });
      }
    };

    await peerConnection.setRemoteDescription(offer);
    console.log('Set remote description:', offer);

    const answer = await peerConnection.createAnswer();
    console.log('Created answer:', answer);

    await peerConnection.setLocalDescription(answer);
    console.log('Set local description:', answer);

    sessionClientAnswer = await sendAnswer(answer);
    console.log('Sent answer, got response:', sessionClientAnswer);

    return true;
  } catch (error) {
    console.error('Error in connectAvatar:', error);
    if (window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler('Flutter', {
        type: 'error',
        message: error.message
      });
    }
    throw error;
  }
}

// Function to make the avatar speak
async function speakMessage(text) {
  if (!peerConnection || peerConnection.connectionState !== 'connected') {
    console.error('Not connected to avatar');
    return;
  }

  try {
    // First get chat response
    const chatResponse = await fetch('http://127.0.0.1:8000/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ message: text })
    });
    
    if (!chatResponse.ok) {
      throw new Error('Failed to get chat response');
    }

    const chatData = await chatResponse.json();
    const responseText = chatData.response;

    // Now make the avatar speak the response
    const response = await fetch(`${SPEAK_API}/${streamId}`, {
      method: 'POST',
      headers: {
        Authorization: 'Basic ' + btoa('test:test'),
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        script: {
          type: 'text',
          input: responseText,
        },
        driver_url: 'bank://lively/',
        config: {
          stitch: true,
        },
        session_id: sessionId,
      }),
    });

    if (!response.ok) {
      throw new Error('Failed to send speak request');
    }

    // Notify Flutter about the response
    if (window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler('Flutter', {
        type: 'speaking',
        text: responseText,
        options: chatData.options || []
      });
    }

    return responseText;
  } catch (error) {
    console.error('Error in speakMessage:', error);
    if (window.flutter_inappwebview) {
      window.flutter_inappwebview.callHandler('Flutter', {
        type: 'error',
        message: error.message
      });
    }
    throw error;
  }
}

async function createStream() {
  const response = await fetch(SPEAK_API, {
    method: 'POST',
    headers: {
      Authorization: 'Basic ' + btoa('test:test'),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      source_url: 'bank://lively/',
    }),
  });

  if (!response.ok) {
    throw new Error('Failed to create stream');
  }

  const { id, offer, ice_servers, session_id } = await response.json();
  streamId = id;
  sessionId = session_id;
  return { offer, iceServers: ice_servers, streamId: id };
}

async function sendAnswer(answer) {
  const response = await fetch(`${SPEAK_API}/${streamId}/sdp`, {
    method: 'POST',
    headers: {
      Authorization: 'Basic ' + btoa('test:test'),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ answer, session_id: sessionId }),
  });

  if (!response.ok) {
    throw new Error('Failed to send answer');
  }

  return response.json();
}

async function sendICECandidate(candidate) {
  const response = await fetch(`${SPEAK_API}/${streamId}/ice`, {
    method: 'POST',
    headers: {
      Authorization: 'Basic ' + btoa('test:test'),
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ candidate, session_id: sessionId }),
  });

  if (!response.ok) {
    throw new Error('Failed to send ICE candidate');
  }

  return response.json();
}

// Cleanup function
async function disconnectAvatar() {
  if (peerConnection) {
    peerConnection.close();
    peerConnection = null;
  }
  streamId = null;
  sessionId = null;
  sessionClientAnswer = null;
}

window.connectAvatar = connectAvatar;
window.speakMessage = speakMessage;
window.disconnectAvatar = disconnectAvatar;
