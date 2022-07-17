import UIKit

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
 */


// MARK: - Subjects
///Un sujeto es un tipo reactivo que es tanto una secuencia observable como un observador. Pueden aceptar suscripciones y emitir eventos, así como agregar nuevos elementos a la secuencia. Hay cuatro tipos de asunto: PublishSubject , BehaviorSubject , Relay(Variable), ReplaySubject
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
