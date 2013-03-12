	
#include <windows.h>
#include <cstdlib>
#include <gl\glut.h>	
#include <il\il.h>
#include <il\ilu.h>


//����������� 2 �������
GLUquadric *obj = NULL;
float dt = 0.0f;

// ����������� ����
void redraw()
{
    glClear(GL_COLOR_BUFFER_BIT);
	glLoadIdentity();
	glTranslatef(0.0f, 0.0f, -3); 
	glRotatef(dt, 1.0f, 0.0f, 0.0f);
	glRotatef(dt, 0.0f, 1.0f, 0.0f);
	glRotatef(dt, 0.0f, 0.0f, 1.0f);
	dt += 0.8;
	gluSphere(obj, 0.5f, 8, 8);	
	glFlush();
	glutSwapBuffers();
}

// ���������� �� ��������� ������� ����
void reshape(int width, int height)
{
	if (height == 0) 
		height = 1;
	glViewport(0, 0, width, height);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(45.0, width/height, 0.001, 1000.0);  
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}


// ���������� ����������
void keyboard(unsigned char key, int x, int y)
{
	switch (key) {
		case 27 : exit(0); break;
	}
}



int main(int argc, char* argv[])
{
		
	const char *FileName  = "OpenIL.tif";
	glutInit(&argc, argv);
	glutInitWindowSize(800, 600);
    glutInitDisplayMode(GLUT_RGBA | GLUT_DOUBLE);
    glutCreateWindow("Formats");
    glutIdleFunc(redraw);
    glutDisplayFunc(redraw);
    glutReshapeFunc(reshape);
	glutKeyboardFunc(keyboard);

	glClearColor(0.5, 0.5, 0.5, 1.0);
	glEnable(GL_TEXTURE_2D);
	//������������ ����������
	ilInit();
	//�������� ����� c��������������� ����
	//� ������ ������ png
	ilLoad(IL_TIF, (const ILstring)FileName);	
	//��������� ���� ������
	int err = ilGetError();
	//���� ��� �� ����� ���� ��
	if (err != IL_NO_ERROR) {
		//��������� ������ � �������
		const char* strError = iluErrorString(err);
		MessageBox(NULL, strError, "Error", MB_OK);
		exit(1);
	}
	//������ �����������
	int width = ilGetInteger(IL_IMAGE_WIDTH); 
	//����� �����������
	int height = ilGetInteger(IL_IMAGE_HEIGHT); 
	//����� ���� �� �������	
	int bpp = ilGetInteger(IL_IMAGE_BYTES_PER_PIXEL); 	
	//������ ������
	int size = width * height * bpp;
	//������ ��� ������
	unsigned char* data = new unsigned char[size];
	//��������� ��������� ������
	unsigned char *copyData = ilGetData();
	//����������� ��������� ������
	memcpy(data, copyData, size);
	//��� �������� ������
	unsigned int type;
	//�������������� ��� ��� OpenGL
	switch (bpp) {
		case 1:	
			type  = GL_RGB8;
		break;
		case 3:
			type = 	GL_RGB;
		break;
		case 4:
			type = GL_RGBA;
		break;
	}
	unsigned int IndexTexture = -1;
	glGenTextures(1, &IndexTexture);  
	glBindTexture(GL_TEXTURE_2D, IndexTexture); 	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 	
	glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
	glTexParameterf(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);	
	gluBuild2DMipmaps(GL_TEXTURE_2D, bpp, width, height, type, 
                      GL_UNSIGNED_BYTE, data);		
	//�������� ��������� �������
	if (data) {
		delete [] data;
		data = NULL;
	}
	//�������� ����������� 2 �������
	obj = gluNewQuadric();
	//���������� ��������� ��������
	gluQuadricTexture(obj, true);
	glutMainLoop();
	//�������� �������� �� �����������
	glDeleteTextures(1, &IndexTexture);
	//�������� ����������� 2 �������
	gluDeleteQuadric(obj);
	obj = NULL;	
	return 0;
}