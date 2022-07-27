import UIKit
import RxCocoa
import RxSwift
/*
 
 
//se crea un observador solo con un elemento
let observable1 = Observable.just(1)

//si nos suscribimos a este observabvle necesitamos obtener estos numeros: 1,2,3
let observable2 = Observable.of(1,2,3)

//es todo el arreglo
let observable3 = Observable.of([1,2,3])

//Será son algunos elementos del arreglo
let observable4 = Observable.from([1,2,3,4,5])

let observable5 = Observable.of("Uno", "Dos","Tres", "Cuatro")

//Crearemos la subscripcion
observable4.subscribe { event in
    //la subscripcion no te dara el valor actual si no el siguiente evento, el siguiente valor del evento
    //print(event)
    
    //cada evento tiene el metodo .element el cual permite acceder al elemento de la lista del observable
    if let element = event.element {
        print("elemento : \(element)") //solo imprime los elementos o valores (1-5)
    }
}

//La principal diferencia entre .from y .of es que en of solo hay un solo evento el cual es ocurre en todo el arreglo, mientras que en .from itera en cada uno de los elementos del arreglo por lo que hay n eventos.
let subscription1 = observable3.subscribe { event in
//    print(event)
    if let element = event.element {
        print("elemento : \(element)")
    }
}

//Hay un método para acceder al valor actual de una lista de un observable:
let subscription2 = observable4.subscribe(onNext: { element in
    print(element)
})

let subscription5 = observable5.subscribe({ (event: Event<String>) in
    print(event)
})

//Necesitamos desechar la subscripcion una vez que se termina de usar para evitar fugas o pérdidas de memoria, esta es la forma mas facil de desechar las subscripciones pero hay otra forma, ya que tenemos mas de 1 subscripcion
subscription5.dispose()
 
// MARK: - Bolsa de desechos
//Se crea una bolsa de desechos
let disposeBag = DisposeBag()
// MARK: - 1.- Crearemos una secuencia observable, suscribirse a esa secuencia con un controlador de eventos y deshacerse de la suscripción cuando haya terminado.

Observable.of("A", "B", "C")
    .subscribe {
        print($0) //imprime cada evento
    }.disposed(by: disposeBag)

// MARK: - 2.- Tenemos una funcion "crear" subscripciones que nos dará un observador y podremos definir algunas de las funciones: onNext, onComplete, onError
Observable<String>.create { observer in
    observer.onNext("A")
    observer.onNext("?")
    observer.onCompleted()
    //Despues de llamar a onCompleted nunca seguirá ejecutandose el método onNext
    observer.onNext("?")
    return Disposables.create() //esta es la forma de crear la bolsa de desechos
}.subscribe(onNext: { print($0) }, onError: { print($0) }, onCompleted: {print("Completed :) ")}, onDisposed: {print("Disposed :/ ")})
    .disposed(by: disposeBag)
 


// MARK: - Subjects
///Un sujeto es un tipo reactivo que es tanto una secuencia observable como un observador. Pueden aceptar suscripciones y emitir eventos, así como agregar nuevos elementos a la secuencia. Hay cuatro tipos de subjects: PublishSubject , BehaviorSubject , Relay(Variable), ReplaySubject
let disposeBag = DisposeBag()

let subject = PublishSubject<String>()

//Si mandamos un evento antes de crear la subscripcion, no se verá reflejada
subject.onNext("Issue 1") //Nunca se mostrará en  consola

subject.subscribe { event in
    print(event)
}

subject.onNext("Issue 2")
subject.onNext("Issue 3")
subject.onCompleted() //se termina la secuencia de eventos

subject.dispose() //al llamar a desechar, ya no habrá mas métodos onNext, ni tampoco onCompleted

subject.onCompleted()//ya no se mostrará ya que ya se desecho la subscripcion

subject.onNext("Issue 4") //ya no se mostrará ya que ya se desecho la subscripcion
 


// MARK: - BehaviorSubject
 ///BehaviorSubject: almacena el evento next() más reciente, que se puede reproducir para los nuevos suscriptores, un nuevo suscriptor puede recibir el evento next() más reciente incluso si se suscribe después de que se emitió el evento.  No debe tener un búfer vacío, por lo que se inicializa con un valor inicial que actúa como el evento next() inicial, este valor se sobrescribe tan pronto como se agrega un nuevo elemento a la secuencia.
 
// Es muy parecido al PublishSubject a diferencia de que necesita un valor inicial para cuando alguien se suscriba a el, éste le dara ese valor incial o el último valor registrado.
let disposeBag = DisposeBag()

let subject = BehaviorSubject(value: "Initial Value")

//Aqui se muestra el ultimo valor que sobre-escribe al valor inicial o por defecto
subject.onNext("Last Issue ")
subject.onNext("Issue 2")

subject.subscribe { event in
    print(event) //Shows Issue 2 cause is the last value
}

//Aqui se muestra el primer valor por defecto y despues muestra el ultimo valor guardado
//subject.onNext("Issue 1")
 


// MARK: - ReplaySubject
 ///ReplaySubject:  le brinda la posibilidad de reproducir muchos eventos próximos, especifica el tamaño de su búfer cuando crea una instancia de ReplaySubject, y mantiene sus próximos eventos más recientes hasta el límite del búfer. Cuando se agrega un nuevo suscriptor, los eventos almacenados en el búfer se reproducen uno tras otro como si estuvieran ocurriendo en rápida sucesión inmediatamente después de la suscripción. Una vez más, los eventos de parada se vuelven a emitir a los nuevos suscriptores.

let disposeBag = DisposeBag()

let subject = ReplaySubject<String>.create(bufferSize: 2)
//Cuando nuevos suscriptores se suscriban a este sujeto, ellos automaticamente van a reproducir los ultimos n valores que se hayan emitido por el sujeto.
//Si se agregan mas eventos las nuevas subscripciones solo van a emitir los últimos n valores que se hayan emitido -> lines: "142-145"
subject.onNext("Issue 1")
subject.onNext("Issue 2")
subject.onNext("Issue 3")


//Creamos la subscripcion y veamos que pasa:
subject.subscribe {
    print($0) //itera e imprime cada evento
}
subject.onNext("Issue 4")
subject.onNext("Issue 5")
subject.onNext("Issue 6")

print("[Subscription 2]")
subject.subscribe {
    print($0) //itera e imprime cada evento
}

*/


// MARK: - BehaviorRelay
///Relay (Antes Variable): es un envoltorio alrededor de BehaviorSubject que permite un manejo más simple, proporciona una sintaxis de puntos para obtener y establecer un valor único que se emite como un evento next() y se almacena para su reproducción.   La propiedad .value expuesta obtiene y establece el valor en una propiedad _value almacenada de forma privada.   también tiene un método .asObservable() que devuelve el BehaviorSubject privado para administrar sus suscriptores.
    
    //No permiten la terminación anticipada. En otras palabras, no puede enviar un evento de error() o complete() para terminar la secuencia. Simplemente espere a que se desasigne la variable y finalice la secuencia en su método deinit.
let disposeBag = DisposeBag()

let relay = BehaviorRelay(value: "Initial Value")
let relay2 = BehaviorRelay(value: [String]())

//relay2.value.append("Item 1") //No se puede cambiar el valor, para ello hay una funcion llamada .accept
relay2.accept(["Item 1"]) //Esto sobre-escribe el valor pero si queremos añadir
relay2.accept(relay2.value + ["Item 2"])

//Pero hay otra forma de agregar mas valores a un arreglo
var value = relay2.value
value.append("Item 3")
value.append("Item 4")
value.append("Item 5")
relay2.accept(value)

//Sub 1
relay.asObservable()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

//relay.value = "Hi" //No se puede cambiar el valor, para ello hay una funcion llamada .accept
//relay.accept("Hi")

//Sub 2
relay2.asObservable()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)



