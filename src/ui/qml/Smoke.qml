/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1
import QtQuick.Particles 2.0

Rectangle {
    width: 100
    height: 62
    id: smokeRectangle
    color: "transparent"
    state: "ON"

    states: [
        State{
            name: "ON"
            PropertyChanges { target: turb;   enabled: true }
            PropertyChanges { target: flame;  enabled: true }
            PropertyChanges { target: smoke1; enabled: true }
            PropertyChanges { target: smoke2; enabled: true }
        },
        State{
            name: "OFF"
            PropertyChanges { target: turb;   enabled: false }
            PropertyChanges { target: flame;  enabled: false }
            PropertyChanges { target: smoke1; enabled: false }
            PropertyChanges { target: smoke2; enabled: false }
        }

    ]


    ParticleSystem {
        id: particle_system
        anchors.fill: parent

        //! [0]
        Turbulence {
            id: turb
            enabled: true
            height: (parent.height / 2) - 4
            width: parent.width
            //height: 500
            //width: 500
            x: parent. width / 4
            anchors.fill: parent
            strength: 32
            NumberAnimation on strength{from: 16; to: 64; easing.type: Easing.InOutBounce; duration: 1800; loops: -1}
        }
        //! [0]

        ImageParticle {
            groups: ["smoke"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#11111111"
            colorVariation: 0
        }
        ImageParticle {
            groups: ["flame"]
            source: "qrc:///particleresources/glowdot.png"
            color: "#11111111"
            colorVariation: 0.1
        }
        Emitter {
            id: flame
            anchors.centerIn: parent
            group: "flame"

            emitRate: 120
            lifeSpan: 1200
            size: 20
            endSize: 10
            sizeVariation: 10
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 20; angleVariation: 22; magnitudeVariation: 5 }
        }
        TrailEmitter {
            id: smoke1
            enabled: true
            width: 500
            height: 500/2
            group: "smoke"
            follow: "flame"

            emitRatePerParticle: 1
            lifeSpan: 2400
            lifeSpanVariation: 400
            size: 16
            endSize: 8
            sizeVariation: 8
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 22; magnitudeVariation: 5 }
        }
        TrailEmitter {
            id: smoke2
            enabled: true
            width: 500
            height: 500/2 - 20
            group: "smoke"
            follow: "flame"

            emitRatePerParticle: 4
            lifeSpan: 2400
            size: 36
            endSize: 24
            sizeVariation: 12
            acceleration: PointDirection { y: -40 }
            velocity: AngleDirection { angle: 270; magnitude: 40; angleVariation: 22; magnitudeVariation: 5 }
        }
    }

}
