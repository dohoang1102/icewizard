//
//  Shader.fsh
//  FirenIce
//
//  Created by Per Borgman on 2010-05-07.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
