import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { FilmesModule } from './filmes/filmes.module';
import { ListagemFilmesComponent } from './filmes/listagem-filmes/listagem-filmes.component';
import { ListagemFilmesSimplesComponent } from './filmes/listagem-filmes-simples/listagem-filmes-simples.component';

const routes: Routes = [

  {
      path: '',
      redirectTo: 'filmes',
      pathMatch: 'full'
  },
  {
    path: 'filmes',
    children: [
      {
        path: '',
        component: ListagemFilmesComponent
      }
    ]
  },

  {
    path: 'simples',
    children: [
      {
        path: '',
        component: ListagemFilmesSimplesComponent
      },
     
    ]
  },



  { path: '**', redirectTo: 'filmes' },

];

@NgModule({
  imports: [
    RouterModule.forRoot(routes),
    FilmesModule
  ],
  exports: [RouterModule]
})
export class AppRoutingModule { }
