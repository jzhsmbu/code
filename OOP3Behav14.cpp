#include "pt4.h"
using namespace std;

class Request
{
public:
    virtual string ToStr() = 0;
};

// Implement the RequestA and RequestB descendant classes

class RequestA : public Request
{
	int param;
public:
	RequestA(int param);
	virtual int GetParam();
	virtual string ToStr();
};

RequestA::RequestA(int param)
{
	this->param=param;
}

int RequestA::GetParam()
{
	return param;	
}

string RequestA::ToStr()
{
	string s;
	s="A:" + to_string(param);
	return s;
}

class RequestB : public Request
{
	string param;
public:
	RequestB(string param);
	virtual string GetParam();
	virtual string ToStr();	
};

RequestB::RequestB(string param)
{
	this->param=param;
}

string RequestB::GetParam()
{
	return param;	
}

string RequestB::ToStr()
{
	string s;
	s="B:" + param;
	return s;
}

class Handler
{
    Handler* successor;
public:
    Handler(Handler* successor) : successor(successor) {}
    virtual void HandleRequest(Request* req);
    virtual ~Handler();
};

void Handler::HandleRequest(Request* req)
{
    // Implement the method
    if(successor!=NULL)
    {
    	successor->HandleRequest(req);
	}
	else
	{
		string s,s1;
		s=req->ToStr();
		s1="Request "+s+" not processed";
		Show(s1);
		pt << s1;
	}
    
}
Handler::~Handler()
{
    // Implement the destructor
    delete successor;
    
}

// Implement the HandlerA and HandlerB descendant classes

class HandlerA : public Handler
{
	int id;
	int param1;
	int param2;
	Request* req;
public:
	HandlerA(Handler* successor, int id, int param1, int param2) : Handler(successor), id(id), param1(param1), param2(param2){}
	virtual void HandleRequest(Request* req);
};

void HandlerA::HandleRequest(Request* req)
{
	int object;
	string s=req->ToStr();
	if(s[0]=='A')
	{
		object=stoi(s.substr(2));
		if(object>=param1 && object<=param2)
		{
			string s1;
			s1="Request "+s+" processed by handler "+to_string(id);
			Show(s1);
			pt << s1;
		}
		else
		{
			Handler::HandleRequest(req);
		}
	}
	else
	{
		Handler::HandleRequest(req);
	}

	
}

class HandlerB:public Handler
{
	int id;
	string param1;
	string param2;
	Request* req;
public:
	HandlerB(Handler* successor, int id, string param1, string param2) : Handler(successor), id(id), param1(param1), param2(param2){}
	virtual void HandleRequest(Request* req);
};

void HandlerB::HandleRequest(Request* req)
{
	string object;
	string s=req->ToStr();
	if(s[0]=='B')
	{
		object=s.substr(2);
		if(object>=param1 && object<=param2)
		{
			string s1;
			s1="Request "+s+" processed by handler "+to_string(id);
			Show(s1);
			pt << s1;
		}
		else
		{
			Handler::HandleRequest(req);
		}
	}
	else
	{
		Handler::HandleRequest(req);
	}

	
}


class Client
{
    Handler* h;
public:
    Client(Handler* h) : h(h) {}
    void SendRequest(Request* req);
    ~Client();
};

void Client::SendRequest(Request* req)
{
    h->HandleRequest(req);
}
Client::~Client()
{
    // Implement the destructor
    delete h; 
}

void Solve()
{
    Task("OOP3Behav14");
    int N;
    pt >> N;
    char c;
    int a,b;
    string m,n;
    Handler* H = new Handler(NULL);
    
    for(int id=0;id<N;id++)
    {
    	pt >> c;
    	if(c=='A')
    	{
    		pt >> a >> b;
    		H=new HandlerA(H,id,a,b);
		}
		else
		{
			pt >> m >> n;
			H=new HandlerB(H,id,m,n);
		}
	}
	
	int K;
	pt >> K;
	int p;
	string q;
	char c1;
	Client C(H);
	
	for(int i=0;i<K;i++)
	{
		pt >> c1;
    	if(c1=='A')
    	{
    		pt >> p;
    		C.SendRequest(new RequestA(p));
		}
		else
		{
			pt >> q;
			C.SendRequest(new RequestB(q));
		}
	}

}
