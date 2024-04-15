use yew::prelude::*;
//use yew_router::prelude::*;

// read at compile time
// const ACTIX_PORT: &str = std::env!("ACTIX_PORT");
// const SPRING_PORT: &str = std::env::var("SPRING_PORT");
// const SPRING_PORT: &str = std::env!("SPRING_PORT");

#[function_component]
fn App() -> Html {
    let counter = use_state(|| 0);
    let onclick = {
        let counter = counter.clone();
        move |_| {
            let value = *counter + 1;
            counter.set(value);
        }
    };

    html! {
        <div>
            <button {onclick}>{ "+1" }</button>
            <p>{ *counter }</p>
        </div>
    }
}

fn main() {
    yew::Renderer::<App>::new().render();
}


