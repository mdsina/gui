	
#include <windows.h>
#include <cstdlib>
#include <gl\glut.h>	
#include <il\il.h>
#include <il\ilu.h>


//Поверхность 2 порядка
GLUquadric *obj = NULL;
float dt = 0.0f;

// перерисовка окна
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

// обработчик на изменение размера окна
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


// обработчик клавиатуры
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
	//Инциализация библиотеки
	ilInit();
	//Загрузка файла cоответствующего типа
	//В данном случае png
	ilLoad(IL_TIF, (const ILstring)FileName);	
	//Получение кода ошибки
	int err = ilGetError();
	//Если код не равен нулю ош
	if (err != IL_NO_ERROR) {
		//Получение строки с ошибкой
		const char* strError = iluErrorString(err);
		MessageBox(NULL, strError, "Error", MB_OK);
		exit(1);
	}
	//Ширина изображения
	int width = ilGetInteger(IL_IMAGE_WIDTH); 
	//Выота изображения
	int height = ilGetInteger(IL_IMAGE_HEIGHT); 
	//Число байт на пиксель	
	int bpp = ilGetInteger(IL_IMAGE_BYTES_PER_PIXEL); 	
	//Размер памяти
	int size = width * height * bpp;
	//Память под массив
	unsigned char* data = new unsigned char[size];
	//Получение растровых данных
	unsigned char *copyData = ilGetData();
	//Копирование растровых данных
	memcpy(data, copyData, size);
	//Тип хранения данных
	unsigned int type;
	//переопределить тип для OpenGL
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
	//Удаление ненужного массива
	if (data) {
		delete [] data;
		data = NULL;
	}
	//Создание поверхности 2 порядка
	obj = gluNewQuadric();
	//разрешение наложения текстуры
	gluQuadricTexture(obj, true);
	glutMainLoop();
	//Удаление текстуры из видеопамяти
	glDeleteTextures(1, &IndexTexture);
	//Удаление поверхности 2 порядка
	gluDeleteQuadric(obj);
	obj = NULL;	
	return 0;
}