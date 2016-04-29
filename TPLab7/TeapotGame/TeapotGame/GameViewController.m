//
//  GameViewController.m
//  TeapotGame
//
//  Created by fpmi on 26.04.16.
//  Copyright (c) 2016 fpmi. All rights reserved.
//

#import "GameViewController.h"
#import <OpenGLES/ES2/glext.h>

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

// Uniform index.
enum
{
    UNIFORM_MODELVIEWPROJECTION_MATRIX,
    UNIFORM_NORMAL_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// Attribute index.
enum
{
    ATTRIB_VERTEX,
    ATTRIB_NORMAL,
    NUM_ATTRIBUTES
};

GLfloat gCubeVertexData[216] = 
{
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    0.25f, -0.25f, -0.25f,        1.0f, 0.0f, 0.0f,
    0.25f, 0.25f, -0.25f,         1.0f, 0.0f, 0.0f,
    0.25f, -0.25f, 0.25f,         1.0f, 0.0f, 0.0f,
    0.25f, -0.25f, 0.25f,         1.0f, 0.0f, 0.0f,
    0.25f, 0.25f, -0.25f,          1.0f, 0.0f, 0.0f,
    0.25f, 0.25f, 0.25f,         1.0f, 0.0f, 0.0f,
    
    0.25f, 0.25f, -0.25f,         0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    0.25f, 0.25f, 0.25f,          0.0f, 1.0f, 0.0f,
    0.25f, 0.25f, 0.25f,          0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 1.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 1.0f, 0.0f,
    
    -0.5f, 0.5f, -0.5f,        -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, 0.5f, 0.5f,         -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, -0.5f,       -1.0f, 0.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        -1.0f, 0.0f, 0.0f,
    
    -0.5f, -0.5f, -0.5f,       0.0f, -1.0f, 0.0f,
    0.25f, -0.25f, -0.25f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, -1.0f, 0.0f,
    0.25f, -0.25f, -0.25f,        0.0f, -1.0f, 0.0f,
    0.25f, -0.25f, 0.25f,         0.0f, -1.0f, 0.0f,
    
    0.25f, 0.25f, 0.25f,          0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    0.25f, -0.25f, 0.25f,         0.0f, 0.0f, 1.0f,
    0.25f, -0.25f, 0.25f,         0.0f, 0.0f, 1.0f,
    -0.5f, 0.5f, 0.5f,         0.0f, 0.0f, 1.0f,
    -0.5f, -0.5f, 0.5f,        0.0f, 0.0f, 1.0f,
    
    0.25f, -0.25f, -0.25f,        0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    0.25f, 0.25f, -0.25f,         0.0f, 0.0f, -1.0f,
    0.25f, 0.25f, -0.25f,         0.0f, 0.0f, -1.0f,
    -0.5f, -0.5f, -0.5f,       0.0f, 0.0f, -1.0f,
    -0.5f, 0.5f, -0.5f,        0.0f, 0.0f, -1.0f
};

@interface GameViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *gestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *upSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *downSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UIPinchGestureRecognizer *pinch;
@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;
@property bool rotate;
@property bool rotateToUp;
@property bool rotateToLeft;
@property int size;
@property float toRightLeft;

@property float toUpDown;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;
@end

@implementation GameViewController
int standartSize = 6;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    _doubleTapRecognizer.numberOfTapsRequired = 2;
    _rightSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    _leftSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    _upSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    _downSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    //_doubleTapRecognizer.numberOfTouchesRequired = 2;
    _size = 6;
    _toRightLeft = 0.0f;
    _toUpDown = 0.0f;
    _pinch.scale = 3.5f;
    _rotate = false;
    _rotateToLeft =_rotateToUp = true;
    [self setupGL];
}

- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
    
    self.effect = [[GLKBaseEffect alloc] init];
    self.effect.light0.enabled = GL_TRUE;
    self.effect.light0.diffuseColor = GLKVector4Make(1.0f, 0.4f, 0.4f, 1.0f);
    
    glEnable(GL_DEPTH_TEST);
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(gCubeVertexData), gCubeVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 24, BUFFER_OFFSET(12));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

#pragma mark - GLKView and GLKViewController delegate methods
- (IBAction)tapDone:(UITapGestureRecognizer *)sender
{
    _rotate=!_rotate;
    
}
- (IBAction)doubleTapDone:(UITapGestureRecognizer *)sender
{
    if(_size<standartSize)
    {
        _size=_size+3;
    }
    else
    {
        _size = _size-3;
    }
    
}
- (IBAction)rightSwipe:(UISwipeGestureRecognizer *)sender
{
    _rotateToLeft = false;
    _toRightLeft+=0.1f;
}
- (IBAction)leftSwipe:(UISwipeGestureRecognizer *)sender
{
    _rotateToLeft = true;
    _toRightLeft-=0.1f;
}
- (IBAction)upSwipe:(UISwipeGestureRecognizer *)sender
{
    _rotateToUp = true;
    _toUpDown-=0.1f;
}
- (IBAction)downSwipe:(UISwipeGestureRecognizer *)sender
{
    _rotateToUp=false;
    _toUpDown+=0.1f;
}
- (void)update
{
    float aspect = fabsf(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 baseModelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -_size);
    baseModelViewMatrix = GLKMatrix4Rotate(baseModelViewMatrix, _toRightLeft, 0, 1.f, 0.0f);
    
    // Compute the model view matrix for the object rendered with GLKit
   GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, _toUpDown, 1.0f, 0.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Multiply(baseModelViewMatrix, modelViewMatrix);
    
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    //CGAffineTransformScale(self., pinchRecognizer.scale, pinchGestureRecognizer.scale);
    

    //_rotation += self.timeSinceLastUpdate * 0.5f;
    if(_rotate)
    {
        if(_rotateToUp)
        {
            _toUpDown-=0.1f;
        }
        else
        {
            _toUpDown+=0.1f;
        }
        if(_rotateToLeft)
        {
            _toRightLeft-=0.1f;
        }
        else
        {
            _toRightLeft+=0.1f;
        }
    }
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    glClearColor(0.65f, 0.65f, 0.65f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glBindVertexArrayOES(_vertexArray);
    
    // Render the object with GLKit
    [self.effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
    // Render the object again with ES2
    glUseProgram(_program);
    
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX], 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(uniforms[UNIFORM_NORMAL_MATRIX], 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

#pragma mark -  OpenGL ES 2 shader compilation

- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    _program = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(_program, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(_program, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(_program, GLKVertexAttribPosition, "position");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "normal");
    
    // Link program.
    if (![self linkProgram:_program]) {
        NSLog(@"Failed to link program: %d", _program);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (_program) {
            glDeleteProgram(_program);
            _program = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms[UNIFORM_MODELVIEWPROJECTION_MATRIX] = glGetUniformLocation(_program, "modelViewProjectionMatrix");
    uniforms[UNIFORM_NORMAL_MATRIX] = glGetUniformLocation(_program, "normalMatrix");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(_program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(_program, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

@end
