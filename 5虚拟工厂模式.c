#include "pt4.h"
#include <algorithm>
#include <iostream>
#include <string>
using namespace std;

string transf(string text, string front, string after)
{
    return front + text + after;
}

class AbstractButton
{
public:
    virtual string GetControl() = 0;
};

// Implement the Button1 and Button2 descendant classes
class Button1 : public AbstractButton
{
    string text;
public:
    Button1(string text);
    virtual string GetControl();
};
class Button2 : public AbstractButton
{
    string text;
public:
    Button2(string text);
    virtual string GetControl();
};
Button1::Button1(string text)
{
    transform(text.begin(), text.end(), text.begin(), ::toupper);
    this->text = transf(text, "[", "]");
}
Button2::Button2(string text)
{
    transform(text.begin(), text.end(), text.begin(), ::tolower);
    this->text = transf(text, "<", ">");
}
string Button1::GetControl()
{
    return this->text;
}
string Button2::GetControl()
{
    return this->text;
}


class AbstractLabel
{
public:
    virtual string GetControl() = 0;
};

// Implement the Label1 and Label2 descendant classes
class Label1 : public AbstractLabel
{
    string text;
public:
    Label1(string text);
    virtual string GetControl();
};
class Label2 : public AbstractLabel
{
    string text;
public:
    Label2(string text);
    virtual string GetControl();
};
Label1::Label1(string text)
{
    transform(text.begin(), text.end(), text.begin(), ::toupper);
    this->text = transf(text, "=", "=");
}
Label2::Label2(string text)
{
    transform(text.begin(), text.end(), text.begin(), ::tolower);
    this->text = transf(text, "\"", "\"");
}
string Label1::GetControl() 
{
    return text;
}
string Label2::GetControl()
{
    return text;
}

class ControlFactory
{
public:
    virtual AbstractButton* CreateButton(string text) = 0;
    virtual AbstractLabel* CreateLabel(string text) = 0;
};

// Implement the Factory1 and Factory2 descendant classes
class Factory1 : public ControlFactory
{
public:
    virtual AbstractButton* CreateButton(string text);
    virtual AbstractLabel* CreateLabel(string text);
};
class Factory2 : public ControlFactory
{
public:
    virtual AbstractButton* CreateButton(string text);
    virtual AbstractLabel* CreateLabel(string text);
};
AbstractButton* Factory1::CreateButton(string text)
{
    return new Button1(text);
}
AbstractLabel* Factory1::CreateLabel(string text)
{
    return new Label1(text);
}
AbstractButton* Factory2::CreateButton(string text)
{
    return new Button2(text);
}
AbstractLabel* Factory2::CreateLabel(string text)
{
    return new Label2(text);
}


class Client
{
    // Add required fields
    ControlFactory* f;
    AbstractButton* button;
    AbstractLabel* label;
    string text;
public:
    Client(ControlFactory* f);
    void AddButton(string text);
    void AddLabel(string text);
    string GetControls();
};

Client::Client(ControlFactory* f)
{
    // Implement the constructor
    this->f = f;
    button = NULL;
    label = NULL;
}
void Client::AddButton(string text)
{
    // Implement the method
    button = f->CreateButton(text.substr(2));
    this->text = button->GetControl();
} 
void Client::AddLabel(string text)
{
    // Implement the method
    label = f->CreateLabel(text.substr(2));
    this->text = label->GetControl();
}
string Client::GetControls()
{
    // Remove the previous statement and implement the method
    return this->text;
}

void Solve()
{
    Task("OOP1Creat5");
    Client F1(new Factory1);
    Client F2(new Factory2);
    int N;
    pt >> N;
    string s1="" ,s2="";
    for (int i = 0; i < N; i++)
	{
        string text;
        pt >> text;
        switch (text[0]) 
		{
        case('B'):
            F1.AddButton(text);
            s1+=F1.GetControls();
            
            F2.AddButton(text);
            s2+=F2.GetControls();
            
            if(i<N-1)
            {
            	s1+=" ";
            	s2+=" ";
			}
            break;
        case('L'):
            F1.AddLabel(text);
            s1+=F1.GetControls();
            
            F2.AddLabel(text);
            s2+=F2.GetControls();
            
            if(i<N-1)
            {
            	s1+=" ";
            	s2+=" ";
			}
            break;     
        }
         
    }
    //Show(s1);
    //Show(s2);
    pt << s1;
    pt << s2;
	  
}