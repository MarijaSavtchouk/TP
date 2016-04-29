//
//  Shader.fsh
//  TeapotGame
//
//  Created by fpmi on 26.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
